
# Animated Infinite Scroll view

### load and display small chunks of items as the user scrolls down the screen

### Overview:

![](https://s10.gifyu.com/images/20220422_002203.gif)

## 1- Declare a PaginationController extends `AnimatedInfinitePaginationController<T>`

* **PaginationController** the layer between **user interface** and **model** which is handled by a repository.
* **T** is Type of your data list. for Example if you have  `List<User>` , you will create a **paginationController** extends `AnimatedInfinitePaginationController<User>`.

Before create the PaginationController we're going to create our **Repository** which get the data from backend (data source)

The Repository will be like this:
```dart
import 'dart:async';
import 'dart:convert';
import 'package:example/config/env.dart';
import 'package:example/models/users_list.dart';
import 'package:example/models/users_response.dart';
import 'package:http/http.dart' as http;

class UserRepository {

  Future<UsersList?> getUsersList(int page) async {
    /// fetch data from server
    final api = "${Env.paginationApi}/users?page=$page&limit=${Env.perPage}";
    final http.Response response = await http.get(Uri.parse(api));
    final responseData = UserResponse.fromJson(jsonDecode(response.body));
    
    /// responseData.usersList -> json: { "users": [], "total": 100 }
    return responseData.usersList;
  }
}

```
Now we're going to create our **PaginationController**.
The PaginationController will be something like this:
```dart
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import '../../models/data/user.dart';

class UsersPaginationController with AnimatedInfinitePaginationController<User> {
  final repository = UserRepository();

  /// decide whether two object represent the same Item
  @override
  bool areItemsTheSame(User a, User b) {
    return a.id == b.id;
  }

  /// fetch data from repository and emit new state
  ///
  /// set total items count -> stop loading on last page
  /// 
  /// use [emitState] to reflect new pagination-state to UI
  @override
  Future<void> fetchData(int page) async {
    // emit loading
    emitState(const PaginationLoadingState());

    try {
      // fetch data from server
      final data = await repository.getUsersList(page);
      if (data?.total != null && data?.users != null) {
        // emit fetched data
        // when emit remote data after cached data with same page,
        // controller will replace the cached data with remote data
        emitState(PaginationSuccessState(data!.users!, cached: false));

        // tell the controller the total of items,
        // this will stop loading more data when last data-chunk is loaded.
        setTotal(data.total!);
      }
    } catch (error) {
      if (kDebugMode) print(error);
      // emit error
      emitState(const PaginationErrorState());
    }
  }

  /// remove an item from users list
  void remove(User user) {
    // find index of user in items list
    final index = items.value.indexWhere((element) => element.item.id == user.id);
    // `deleteItem` is a method declared in `AnimatedInfinitePaginationDelegate`
    // which expected an integer value `index of item`
    if (index != -1) deleteItem(index);
  }
}
```

## 2- UI:
* Declare your view-model in your screen:
```dart
import 'package:flutter/material.dart';
import '../controllers/users_pagination_controller.dart';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';

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

  /// remove user from list
  void deleteUser(User user) {
    controller.remove(user);
  }
}

```
* Wrap the animated scrollView in your screen:
```dart
@override
Widget build(BuildContext context) {
  return AnimatedInfiniteScrollView<User>(
      controller: controller,
      options: AnimatedInfinitePaginationOptions(
          // customize your loading widget
          loadingWidget: const Center(child: AppProgressBar()),

          // customize your pagination loading widget
          footerLoadingWidget: const AppProgressBar(),
          
          // customize your error widget
          errorWidget: TextButton(
            onPressed: controller.fetchNewChunk, // re-fetch data
            child: Text(
              "Fetching data failed, Try Again",
              style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
            ),
          ),

          // appears after fetch first page data and the result is empty
          noItemsWidget: Center(
            child: Text("No Data Found"),
          ),
          
          // item widget builder
          itemBuilder: (BuildContext context, User item, int index) {
            return UserCard(user: item, onDelete: deleteUser);
          },
          
          /// warp [ScrollView] in [RefreshIndicator] 
          refreshIndicator: true,

          // handle swipe refresh event
          onRefresh: () {
            // ...
          }
      ),
  );
}
```

### GridView
* enable pagination in **GridView**:
```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return AnimatedInfiniteScrollView<User>(
      controller: controller,
      options: AnimatedInfinitePaginationOptions(
          // add gridDelegate to display this pagination list in GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),

          // item widget builder
          itemBuilder: (BuildContext context, User item, int index) {
            return UserCard(user: item, onDelete: deleteUser);
          },

          // ...
      ),
  );
}
```

### Scroll Direction:
* enable pagination in **horizontal** scroll:
```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return AnimatedInfiniteScrollView<User>(
      controller: controller,
      options: AnimatedInfinitePaginationOptions(
          // set scrollDirection
          scrollDirection: Axis.horizontal,

          // width of child is required when (scrollDirection = Axis.horizontal)
          itemBuilder: (context, item, index) => SizedBox(
            width: size.width * 0.8,
            child: UserCard(user: item, onDelete: deleteUser),
          ),

          // ...
      ),
  );
}
```

### Top Widgets:
* add **top widgets** above the scrollView:
```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return AnimatedInfiniteScrollView<User>(
      controller: controller,
      options: AnimatedInfinitePaginationOptions(
          // [SliverCustomWidget] imported automatically from "animated_infinite_scroll_pagination"
          topWidgets: [
            // non sliver widget
            SliverCustomWidget(
              isSliver: false,
              child: Container(
                color: Colors.blue,
                height: size.height / 6,
                child: const Center(
                  child: Text(
                    "Animated Pagination List",
                    style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // sliver widget
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
                    style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],

          // ...
      ),
  );
}
```