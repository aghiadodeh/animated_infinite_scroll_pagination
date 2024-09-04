import 'dart:io';
import 'package:example/models/user.dart';
import 'package:example/ui/widgets/user_card.dart';
import 'package:example/ui/controllers/users_pagination_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final controller = UsersPaginationController();

  @override
  void initState() {
    super.initState();
    controller.fetchNewChunk(); // fetch first chunk of data from server
  }

  deleteUser(User user) {
    controller.remove(user);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedInfiniteScrollView<User>(
      delegate: controller,
      options: AnimatedInfinitePaginationOptions(
        // customize your loading widget
        loadingWidget: const Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: AppProgressBar(),
          ),
        ),
        // customize your pagination loading widget
        footerLoadingWidget: const AppProgressBar(),
        // customize your error widget
        errorWidget: const Text("Pagination Error"),
        itemBuilder: (context, item, index) => UserCard(user: item, onDelete: deleteUser),
        refreshIndicator: true,
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key});

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
