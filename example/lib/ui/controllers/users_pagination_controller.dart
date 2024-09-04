import 'dart:async';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:example/models/user.dart';
import 'package:example/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class UsersPaginationController with AnimatedInfinitePaginationController<User> {
  final repository = UserRepository();

  @override
  bool areItemsTheSame(User a, User b) {
    return a.id == b.id;
  }

  @override
  Future<void> fetchData(int page) async {
    // emit loading
    emitState(const PaginationLoadingState());

    try {
      // fetch data from server
      final data = await repository.getUsersList(page);

      // tell the controller the total of items,
      // this will stop loading more data when last data-chunk is loaded.
      if (data?.total != null && data?.users != null) {
        // emit fetched data
        emitState(PaginationSuccessState(data!.users!));
        setTotal(data.total!);
      }
    } catch (error) {
      if (kDebugMode) print(error);
      // emit error
      emitState(const PaginationErrorState());
    }
  }

  void remove(User user) {
    final index = items.value.indexWhere((element) => element.item.id == user.id);
    // `deleteItem` is a method declared in `AnimatedInfinitePaginationDelegate`
    // which expected an integer value `index of item`
    if (index != -1) deleteItem(index);
  }
}
