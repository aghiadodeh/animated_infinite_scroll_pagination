import 'package:example/models/users_list.dart';

class UserResponse {
  UserResponse({
    this.status,
    this.usersList,
    this.message,
  });

  UserResponse.fromJson(dynamic json) {
    status = json['status'];
    usersList = UsersList.fromJson(json['data']);
    message = json['message'];
  }

  bool? status;
  UsersList? usersList;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['data'] = usersList;
    map['message'] = message;
    return map;
  }
}
