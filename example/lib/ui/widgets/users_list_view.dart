import 'dart:io';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:example/models/user.dart';
import 'package:example/ui/widgets/user_card.dart';
import '../controllers/users_pagination_controller.dart';
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
    final size = MediaQuery.of(context).size;

    return AnimatedInfiniteScrollView<User>(
      controller: controller,
      options: AnimatedInfinitePaginationOptions(
        // scrollDirection: Axis.horizontal,

        // top widgets
        topWidgets: [
          SliverCustomWidget(
            isSliver: false,
            child: Container(
              color: Colors.blue,
              height: size.height / 6,
              child: const Center(
                child: Text(
                  "Animated Pagination List",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SliverCustomWidget(
            child: const SliverAppBar(
              /// Properties of app bar
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              expandedHeight: 100.0,

              /// Properties of the App Bar when it is expanded
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "SliverList Widget",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
        errorWidget: TextButton(
          onPressed: controller.fetchNewChunk,
          child: Text(
            "Fetching data failed, Try Again",
            style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
          ),
        ),
        itemBuilder: (context, item, index) => UserCard(user: item, onDelete: deleteUser),
        refreshIndicator: true,
        noItemsWidget: Center(
          child: Text("No Data Found"),
        ),

        // width of child is required when (scrollDirection = Axis.horizontal)
        // itemBuilder: (context, item, index) => SizedBox(
        //   width: size.width * 0.8,
        //   child: UserCard(user: item, onDelete: deleteUser),
        // ),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 8,
        //   crossAxisSpacing: 8,
        // ),
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
