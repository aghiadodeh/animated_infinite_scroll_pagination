import 'dart:async';

import '../models/pagination_model.dart';
import '../models/response_state.dart';
import 'pagination_params.dart';

mixin PaginationViewModel<T, E extends Exception> {
  PaginationParams<T, E> paginationParams = PaginationParams<T, E>();

  Stream<PaginationState> get state => streamSubscription();
  late StreamSubscription _streamSubscription;

  /// listen for new data from your repository
  void listen() {
    _streamSubscription = state.listen((event) {
      switch (event) {
        case PaginationSuccess(:final List<T> data, :final cached):
          paginationParams.isCached = cached;
          _appendData(data);
          break;
        case PaginationError(:final E error):
          paginationParams.idle.postValue(false);
          paginationParams.setError(error);
          break;
        case PaginationLoading():
          paginationParams.setLoading(true);
          break;
      }
    });
  }

  /// fetch new items list from your repository
  Future<void> getPaginationList({int? page}) async {
    if (!paginationParams.loading.value &&
        !paginationParams.lastPage &&
        !paginationParams.isCached) {
      if (page != null) paginationParams.page = page;
      paginationParams.loading.value = true;
      await fetchData(paginationParams.page);
    }
  }

  /// append new data to items-list
  /// remove cached-list when add remote-list with same page
  void _appendData(List<T> data) {
    paginationParams.handleRefresh();
    paginationParams.handleReset();
    paginationParams.idle.postValue(false);

    // remove cached data when remote data is exists
    final items = paginationParams.itemsList.value.toList();
    items.removeWhere((element) => element.page == paginationParams.page);

    // mapping list
    List<PaginationModel<T>> list = data
        .map((e) => PaginationModel(
            id: randomString(), item: e, page: paginationParams.page))
        .toList();

    // update new list
    final newList = items.isNotEmpty ? (items + list).toList() : list;
    paginationParams.itemsList.postValue(newList);

    if (!paginationParams.isCached) incrementPage();
    paginationParams.setLoading(false);
    paginationParams.setError(null);
  }

  /// push new items to start of items-list
  void appendAtFirst(List<T> data) {
    final items = paginationParams.itemsList.value.toList();
    items.insertAll(0,
        data.map((e) => PaginationModel(id: randomString(), item: e, page: 1)));
    paginationParams.itemsList.postValue(items);
  }

  /// increment pagination current page
  void incrementPage() {
    paginationParams.page++;
  }

  /// refresh items-list, reload items from first page.
  void refresh() {
    paginationParams.refresh();
  }

  /// reset items-list, reload items from first page and start from idle state.
  void reset() {
    paginationParams.reset();
  }

  /// remove item from list
  void deleteItem(int index) {
    final items = paginationParams.itemsList.value.toList();
    items.removeAt(index);
    paginationParams.itemsList.postValue(items);
  }

  /// insert new item to list
  void insertItem(int index, T item, int page) {
    final items = paginationParams.itemsList.value.toList();
    items.insert(
        index, PaginationModel(id: randomString(), item: item, page: page));
    paginationParams.itemsList.postValue(items);
  }

  /// empty list
  void clear() {
    paginationParams.itemsList
        .postValue(List<PaginationModel<T>>.empty(growable: true));
    setTotal(0);
  }

  /// call this method when your Widget dispose
  void dispose() {
    paginationParams = PaginationParams<T, E>();
    _streamSubscription.cancel();
  }

  /// set items total count
  void setTotal(int total) {
    paginationParams.total = total;
  }

  /// called by child to fetch data from repository
  Future<void> fetchData(int page);

  /// pagination viewModel refresh items when streamController add new value.
  ///
  /// create a streamController in your repository and add new value when you get new data
  /// from server or sqLite
  Stream<PaginationState> streamSubscription();

  /// decide whether two object represent the same Item
  bool areItemsTheSame(T a, T b);
}
