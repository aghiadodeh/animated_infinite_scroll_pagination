import 'dart:async';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';

mixin PaginationViewModel<T extends Object> {
  PaginationParams<T> paginationParams = PaginationParams<T>();

  Stream<PaginationState<List<T>>> get state => streamSubscription();
  late StreamSubscription _streamSubscription;

  /// listen for new data from your repository
  void listen() {
    _streamSubscription = state.listen((event) {
      if (event is PaginationSuccess) {
        paginationParams.idle.postValue(false);
        final response = (event as PaginationSuccess);
        if (response.data is List<T>) {
          paginationParams.isCached = response.cached;
          _appendData(response.data);
        }
      } else if (event is PaginationError) {
        paginationParams.idle.postValue(false);
        paginationParams.setError(true);
      } else if (event is PaginationLoading) {
        paginationParams.setLoading(true);
      }
    });
  }

  /// fetch new items list from your repository
  Future<void> getPaginationList({int? page}) async {
    if (!paginationParams.loading.value && !paginationParams.lastPage && !paginationParams.isCached) {
      if (page != null) paginationParams.page = page;
      paginationParams.loading.value = true;
      await fetchData(paginationParams.page);
    }
  }

  /// append new data to items-list
  /// remove cached-list when add remote-list with same page
  void _appendData(List<T> data) {
    paginationParams.handleRefresh();

    // remove cached data when remote data is exists
    final items = paginationParams.itemsList.value.toList();
    items.removeWhere((element) => element.page == paginationParams.page);

    // mapping list
    List<PaginationModel<T>> list = data.map((e) => PaginationModel(id: randomString(), item: e, page: paginationParams.page)).toList();

    // update new list
    final newList = items.isNotEmpty ? (items + list).toList() : list;
    paginationParams.itemsList.postValue(newList);

    if (!paginationParams.isCached) incrementPage();
    paginationParams.setLoading(false);
    paginationParams.setError(false);
  }

  /// push new items to start of items-list
  void appendAtFirst(List<T> data) {
    final items = paginationParams.itemsList.value.toList();
    items.insertAll(0, data.map((e) => PaginationModel(id: randomString(), item: e, page: 1)));
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

  /// remove item from list
  void deleteItem(int index) {
    final items = paginationParams.itemsList.value.toList();
    items.removeAt(index);
    paginationParams.itemsList.postValue(items);
  }

  /// insert new item to list
  void insertItem(int index, T item, int page) {
    final items = paginationParams.itemsList.value.toList();
    items.insert(index, PaginationModel(id: randomString(), item: item, page: page));
    paginationParams.itemsList.postValue(items);
  }

  /// empty list
  void clear() {
    paginationParams.itemsList.postValue(List<PaginationModel<T>>.empty(growable: true));
    setTotal(0);
  }

  /// call this method when your Widget dispose
  void dispose() {
    paginationParams = PaginationParams<T>();
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
  Stream<PaginationState<List<T>>> streamSubscription();

  /// decide whether two object represent the same Item
  bool areItemsTheSame(T a, T b);
}
