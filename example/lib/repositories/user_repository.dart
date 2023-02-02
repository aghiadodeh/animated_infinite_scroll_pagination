import 'dart:async';
import 'dart:convert';
import 'package:example/config/env.dart';
import 'package:example/models/users_list.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<UsersList?> getUsersList(int page) async {
    /// fetch data from server
    final skip = (Env.perPage * page) - Env.perPage;
    final api = "${Env.paginationApi}/users?skip=$skip&limit=${Env.perPage}";
    final http.Response response = await http.get(Uri.parse(api));
    final responseData = UsersList.fromJson(jsonDecode(response.body));

    /// responseData.usersList -> json: { "users": [], "total": 100 }
    return responseData;
  }
}
