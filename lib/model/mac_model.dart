import 'package:cloud_firestore/cloud_firestore.dart';

class MacUsers {
  MacUsers({
    this.id,
    required this.isLogin,
    required this.isAdmin,
    required this.isActive,
    required this.value,
  });

  String? id;
  bool isLogin;
  bool isAdmin;
  bool isActive;
  String value;

  factory MacUsers.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    return MacUsers(
      id: json.id,
      isLogin: data["isLogin"],
      isAdmin: data["isAdmin"],
      isActive: data["isActive"],
      value: data["value"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "isLogin": isLogin,
      "isAdmin": isAdmin,
      "isActive": isActive,
      "value": value,
    };
  }
}
