import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationParams<T, E extends Exception> {
  /// check if there is not items after fetch data
  final noItemsFound = MediatorMutableLiveData<bool>(value: false);

  final queryParameters = MediatorMutableLiveData<AbstractQueryParameters>(
      value: const AbstractQueryParameters());

  /// detect if lastPage data is cached data or remote data
  /// send to server new request to fetch new page-list when the lastPage data is not cached
  bool isCached = false;

  /// the total items count (get from response list)
  int total = 0;

  /// current page
  int page = 1;

  /// displayed items List in UI
  final MutableLiveData<List<PaginationModel<T>>> itemsList =
      MutableLiveData(value: List<PaginationModel<T>>.empty(growable: true));

  /// check if user refresh data by `RefreshIndicator`, when true -> reset paginationParams to default value.
  bool isRefresh = false;

  /// is request in loading status
  final MutableLiveData<bool> loading = MutableLiveData(value: false);

  /// server error
  final MutableLiveData<E?> error = MutableLiveData(value: null);

  /// detect if current page is last page -> don't load more data if lastPage is true
  bool get lastPage => total == itemsList.value.length && total != 0;

  /// detect first response
  final MutableLiveData<bool> idle = MutableLiveData(value: true);

  /// set loading value, with hide error
  void setLoading(bool loading) {
    error.postValue(null);
    this.loading.postValue(loading);
  }

  /// set error value, with hide loading
  void setError(E? error) {
    loading.postValue(false);
    this.error.postValue(error);
  }

  /// reset variables to default value
  void refresh() {
    isCached = false;
    isRefresh = true;
    page = 1;
    total = 0;
  }

  /// reset items-list when user refresh data
  /// this operation called when new data fetched
  void handleRefresh() {
    if (isRefresh) {
      isRefresh = false;
      if (itemsList.value.isNotEmpty) {
        itemsList.postValue(List<PaginationModel<T>>.empty(growable: true));
      }
    }
  }

  /// check items after fetched
  void checkFetchedData() {
    final items = itemsList.value;
    noItemsFound.postValue(
        (items.isEmpty && !loading.value && total == 0 && !idle.value) ||
            (noItemsFound.value && loading.value));
  }

  PaginationParams() {
    noItemsFound.addSource(idle, (value) => checkFetchedData());
    noItemsFound.addSource(itemsList, (value) => checkFetchedData());
    noItemsFound.addSource(loading, (value) => checkFetchedData());
  }
}
