abstract class PaginationState {
  const PaginationState();
}

/// A Pagination with initial value
class PaginationInitial extends PaginationState {
  const PaginationInitial();
}

/// A Pagination with error message
class PaginationError<T extends Exception> extends PaginationState {
  final T error;

  const PaginationError(this.error);
}

/// A non complete Pagination
class PaginationLoading extends PaginationState {
  const PaginationLoading();
}

/// A Successfully loaded Pagination
class PaginationSuccess<T> extends PaginationState {
  final T? data;

  /// Data from local storage
  final bool cached;

  const PaginationSuccess(this.data, {this.cached = false});
}
