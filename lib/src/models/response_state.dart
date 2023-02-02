abstract class PaginationState<T> {
  const PaginationState();
}

/// A Pagination with initial value
class PaginationInitial<T> extends PaginationState<T> {
  const PaginationInitial();
}

/// A Pagination with error message
class PaginationError<T> extends PaginationState<T> {
  const PaginationError();
}

/// A non complete Pagination
class PaginationLoading<T> extends PaginationState<T> {
  const PaginationLoading();
}

/// A Successfully loaded Pagination
class PaginationSuccess<T> extends PaginationState<T> {
  final T? data;

  /// Data from local storage
  final bool cached;

  const PaginationSuccess(this.data, {this.cached = false});
}
