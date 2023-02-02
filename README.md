
# Animated Infinite Scroll view

### load and display small chunks of items as the user scrolls down the screen

### Overview:

![](https://s10.gifyu.com/images/20220422_002203.gif)

## 1- Declare View-Model extends `PaginationViewModel<T>`

* **PaginationViewModel** the layer between **user interface** and **model** which is handled by a repository.
* **T** is Type of your data list. for Example if you have  `List<User>` , you will create a **viewModel** extends `PaginationViewModel<User>`.

Before create the View-Model we're going to create our **Repository**.
The Repository is the layer between the View-Model and back-end.

The Repository will be something like this:
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
Now we're going to create our **View-Model**.
The View-Model will be something like this:
```dart
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
    } catch (_) {
      // emit error
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
```

## 2- UI:
* Declare your view-model in your screen:
```dart
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
```
* Wrap the animated scrollView in your screen:
```dart
  deleteUser(User user) {
  viewModel.remove(user);
}

@override
Widget build(BuildContext context) {
  return AnimatedInfiniteScrollView<User>(
      viewModel: viewModel,
      loadingWidget: const AppProgressBar(), // customize your loading widget
      footerLoadingWidget: const AppProgressBar(), // customize your pagination loading widget
      errorWidget: const Text("Pagination Error"), // customize your error widget
      itemBuilder: (item) => UserCard(user: item, onDelete: deleteUser),
      refreshIndicator: true,
      onRefresh: () {
        // handle swipe refresh event
      }
  );
}
```
## **AnimatedInfiniteScrollView** Parameters:
* **viewModel**: The View-Model you declared above in this example *(required)*.
* **topWidget**: a widget you want to place at the top of the first **itemBuilder** widget *(optional)*.
* **loadingWidget**: a widget you want to display when first page is loading *(optional)*.
* **footerLoadingWidget**: a widget you want to display when pagination data is loading *(optional)*.
* **errorWidget**: a widget you want to display when pagination data  is field loading (throw exception) *(optional)*.
* **refreshIndicator**: wrap the scroll view inside a `RefreshIndicator` *(optional)*, **default value** is `false`.
* **itemBuilder**: a widget function which build your **Data Widget** inside the scroll view on Each **Data Item** from list *(required)*.
* **onRefresh**: callback called when user swipe refresh to load new list *(optional)*
* **scrollDirection**: Axis.vertical or Axis.horizontal *(optional)*
* **gridDelegate**: A delegate that controls the layout of the children within the GridView *(optional)*
* **noItemsWidget**: a widget appears after fetch first page data and the result is empty *(optional)*
