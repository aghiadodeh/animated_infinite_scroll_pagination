import 'dart:async';

import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:example/models/user.dart';
import 'package:example/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class UsersViewModel extends PaginationViewModel<User> {
  final repository = UserRepository();
  final _controller = StreamController<PaginationState<List<User>>>();

  Stream<PaginationState<List<User>>> get result async* {
    yield* _controller.stream;
  }

  /// decide whether two object represent the same Item
  @override
  bool areItemsTheSame(User a, User b) {
    return a.id == b.id;
  }

  /// fetch data from repository and emit by Stream to pagination-list
  ///
  /// set total items count -> stop loading on last page
  @override
  Future<void> fetchData(int page) async {
    // emit loading
    _controller.add(const PaginationLoading());
    try {
      final data = await repository.getUsersList(page);
      // tell the view-model the total of items.
      // this will stop loading more data when last data-chunk is loaded
      if (data?.total != null && data?.users != null) {
        // emit data
        _controller.add(PaginationSuccess(data!.users!));
        setTotal(data.total!);
      }
    } catch (error) {
      // emit error
      if (kDebugMode) print(error);
      _controller.add(const PaginationError());
    }
  }

  /// subscribe for list changes
  @override
  Stream<PaginationState<List<User>>> streamSubscription() => result;

  /// remove an item from users list
  void remove(User user) {
    // `paginationParams` is a variable declared in `PaginationViewModel`
    // which contains the List<T>
    final index = paginationParams.itemsList.value.items.indexWhere((element) => element.item.id == user.id);
    // `deleteItem` is a method declared in `PaginationViewModel`
    // which expected a integer value `index of item`
    if (index != -1) deleteItem(index);
  }
}
