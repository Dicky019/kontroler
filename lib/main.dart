import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kontroler/view/admin.dart';
import 'view/login_user.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    // box.remove('isAdmin');
    // box.remove('isLogin');
    String? isLogin = box.read('isLogin');
    String? mac = box.read('mac');
    bool isAdmin = box.read('isAdmin') ?? false;

    return GetMaterialApp(
      theme: ThemeData(
        // primaryColor: Colors.pinkAccent,
        // colorSchemeSeed: Colors.pinkAccent,
        useMaterial3: true,
      ),
      home: isLogin != null
          ? (isAdmin
              ? Admin(id: isLogin)
              : Home(
                  id: isLogin,
                  mac: mac ?? "",
                ))
          : const LoginUser(),
    );
  }
}
