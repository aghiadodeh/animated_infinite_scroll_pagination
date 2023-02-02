import 'user.dart';

class UsersList {
  UsersList({
    this.users,
    this.total,
  });

  UsersList.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(User.fromJson(v));
      });
    }
    total = json['total'];
  }

  List<User>? users;
  int? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    return map;
  }
}
