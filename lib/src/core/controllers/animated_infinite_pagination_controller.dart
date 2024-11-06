import 'package:flutter/material.dart' show debugPrint;
import 'package:flutterx_live_data/flutterx_live_data.dart' show MutableLiveData;
import '../../models/pagination.model/pagination_model.dart';
import '../../models/response_state/response_state.dart';
import '../extensions/live_data_extension.dart';

mixin AnimatedInfinitePaginationController<T> {
  /// the total items count (get from response list).
  int total = 0;

  /// current page.
  int page = 1;

  /// refreshing state
  bool refreshing = false;

  /// detect if last fetched data is cached data or remote data
  /// send to server new request to fetch new page-list when the last fetched data is not cached
  bool get isCached => paginationState.value.state == PaginationStateEnum.cached;

  /// detect if current page is last page -> don't load more data if lastPage is true
  bool get lastPage => total == items.value.length && total != 0;

  /// check if there is no items after fetch data
  late final emptyList = false.liveData;

  /// pagination state.
  late final paginationState = MutableLiveData<PaginationState<T>>(value: PaginationIdleState<T>());

  /// observable data holder for displayed items in UI.
  late final items = List<PaginationModel<T>>.empty(growable: true).liveData;

  /// called by child to fetch data from repository.
  Future<void> fetchData(int page);

  /// decide whether two object represent the same Item.
  bool areItemsTheSame(T a, T b);

  /// set total items count.
  void setTotal(int total) {
    this.total = total;
  }

  /// emit new [PaginationState] to reflect it in UI.
  void emitState(PaginationState<T> state) {
    // update state value
    paginationState.postValue(state);

    // handle new data
    if (state is PaginationSuccessState) {
      final response = (state as PaginationSuccessState<T>);
      _appendData(response.data);
    }
  }

  /// fetch new items list.
  Future<void> fetchNewChunk({int? page}) async {
    // check if current state is loading state or current page is the last page
    if (paginationState.value.state == PaginationStateEnum.loading || lastPage) return;

    // assign new page
    if (page != null) this.page = page;

    // request new data
    await fetchData(this.page);
  }

  /// increment pagination current page
  void incrementPage() {
    page += 1;
  }

  /// handle new chuck of data
  Future<void> _appendData(List<T> data) async {
    // check if new data received after refresh
    if (refreshing && items.value.isNotEmpty) {
      refreshing = false;
      items.postValue(List<PaginationModel<T>>.empty(growable: true));
    }

    // remove cached data when remote data is exists
    final currentItems = items.value.toList();
    currentItems.removeWhere((element) => element.page == page);

    // mapping new list
    final list = data.map((item) => PaginationModel.fromItem(item, page)).toList();

    // update new list
    final newList = currentItems.isNotEmpty ? (currentItems + list).toList() : list;
    items.postValue(newList);

    // increment page
    if (!isCached && newList.isNotEmpty) incrementPage();

    // check if the newList is not empty
    if (page == 1) emptyList.postValue(newList.isNotEmpty);
  }

  /// reset variables to default value
  void refresh() {
    page = 1;
    total = 0;
    refreshing = true;
  }

  /// insert new [item] to list in specific [index]
  void insertItem(int index, T item) {
    try {
      final currentItems = items.value.toList();
      final page = index == 0 ? 1 : currentItems[index - 1].page;
      currentItems.insert(index, PaginationModel.fromItem(item, page));
      items.postValue(currentItems);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  /// update existing [item]
  void updateItem(T item, {required bool Function(T item) findIndex}) {
    final list = items.value.toList();
    final index = list.indexWhere((e) => findIndex(e.item));
    if (index == -1) return;
    deleteItem(index);
    insertItem(index, item);
  }

  /// remove item by [index] from [items]
  void deleteItem(int index) {
    final currentItems = items.value.toList();
    currentItems.removeAt(index);
    items.postValue(currentItems);
  }
}
