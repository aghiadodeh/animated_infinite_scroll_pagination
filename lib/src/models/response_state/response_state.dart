enum PaginationStateEnum { idle, loading, error, remote, cached }

abstract class PaginationState<T> {
  final PaginationStateEnum state;

  const PaginationState(this.state);
}

/// A Pagination with initial value
class PaginationIdleState<T> extends PaginationState<T> {
  const PaginationIdleState() : super(PaginationStateEnum.idle);
}

/// A Pagination with error message
class PaginationErrorState<T> extends PaginationState<T> {
  const PaginationErrorState() : super(PaginationStateEnum.error);
}

/// A non complete Pagination
class PaginationLoadingState<T> extends PaginationState<T> {
  const PaginationLoadingState() : super(PaginationStateEnum.loading);
}

/// A Successfully loaded Pagination
class PaginationSuccessState<T> extends PaginationState<T> {
  final List<T> data;

  /// Data from local storage
  final bool cached;

  const PaginationSuccessState(this.data, {this.cached = false}) : super(cached ? PaginationStateEnum.cached : PaginationStateEnum.remote);
}
