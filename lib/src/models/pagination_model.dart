import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationParams<T extends Object> {
  /// detect if lastPage data is cached data or remote data
  /// send to server new request to fetch new page-list when the lastPage data is not cached
  bool isCached = false;

  /// the total items count (get from response list)
  int total = 0;

  /// current page
  int page = 1;

  /// displayed items List in UI
  final MutableLiveData<PaginationEquatable<T>> itemsList = MutableLiveData(initialValue: const PaginationEquatable());

  /// check if user refresh data by `RefreshIndicator`, when true -> reset paginationParams to default value.
  bool isRefresh = false;

  /// is request in loading status
  final MutableLiveData<bool> loading = MutableLiveData(initialValue: false);

  /// server error
  final MutableLiveData<bool> error = MutableLiveData(initialValue: false);

  /// detect if current page is last page -> don't load more data if lastPage is true
  bool get lastPage => total == itemsList.value.items.length && total != 0;

  /// set loading value, with hide error
  void setLoading(bool loading) {
    error.postValue(false);
    this.loading.postValue(loading);
  }

  /// set error value, with hide loading
  void setError(bool error) {
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
      itemsList.value = const PaginationEquatable();
    }
  }
}

class PaginationModel<T extends Object> {
  final T item;
  final int page;

  const PaginationModel({required this.item, required this.page});
}

class PaginationEquatable<T extends Object> {
  final List<PaginationModel<T>> items;

  const PaginationEquatable({this.items = const []});
}
