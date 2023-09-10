import 'dart:io';

import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:example/models/user.dart';
import 'package:example/ui/widgets/user_card.dart';
import 'package:example/viewmodels/users_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final viewModel = UsersViewModel();

  @override
  void initState() {
    super.initState();
    viewModel
      ..listen() // observe data-list changes when repository update the list
      ..getPaginationList(); // fetch first chunk of data from server
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  deleteUser(User user) {
    viewModel.remove(user);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedInfiniteScrollView<User>.builder(
      viewModel: viewModel,
      loadingWidget: const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: AppProgressBar(),
        ),
      ),
      // customize your loading widget
      footerLoadingWidget: const AppProgressBar(),
      // customize your pagination loading widget
      errorWidget: const Text("Pagination Error"),
      // customize your error widget
      builder: (context, index, item) => UserCard(user: item, onDelete: deleteUser),
      refreshIndicator: true,
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Platform.isIOS
          ? const CupertinoActivityIndicator()
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
    );
  }
}
