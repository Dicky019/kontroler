// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'admin.dart';
import 'home.dart';
import '../widgets/state_home/error.dart';
import '../widgets/state_home/loading.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('mac').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Error();
            } else if (snapshot.hasData) {
              var listData = snapshot.data!.docs;
              return LoginSuccess(listData: listData, firestore: firestore);
              // return Admin(listData: listData, firestore: firestore);
            } else {
              return const Text('Empty data');
            }
          }
          return Text('State: ${snapshot.connectionState}');
        },
      ),
    );
  }
}

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({
    Key? key,
    required this.listData,
    required this.firestore,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>?> listData;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    final controllerMac = TextEditingController();

    showDialogCustom(String text) {
      AlertDialog alert = AlertDialog(
        title: const Text("Ada Yang Salah"),
        content: Text(text),
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    QueryDocumentSnapshot<Map<String, dynamic>>? dataMac;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/login.png',
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerMac,
              onChanged: (v) {
                try {
                  for (var element in listData) {
                    if (element?.data()['value'] == controllerMac.text) {
                      dataMac = element;
                    }
                  }
                } catch (e) {
                  showDialogCustom("Ada Yang Salah");
                }
              },
              decoration: const InputDecoration(
                labelText: 'Mac',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.macwindow,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (dataMac?.data() == null) {
                  showDialogCustom("Anda Salah Mengisih Mac Addres");
                } else {
                  bool isLogin = dataMac?['isLogin'] ?? false;
                  bool isActive = dataMac?['isActive'] ?? false;
                  bool isAdmin = dataMac?['isAdmin'] ?? false;
                  if (isActive) {
                    if (!isLogin) {
                      await firestore.collection('mac').doc(dataMac!.id).update(
                        {
                          "isLogin": true,
                        },
                      );
                      final box = GetStorage();
                      box.write('isLogin', dataMac!.id);
                      box.write('isAdmin', isAdmin);
                      box.write('mac', dataMac!.data()['value']);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isAdmin
                              ? Admin(id: dataMac!.id)
                              : Home(
                                  id: dataMac!.id,
                                  mac: dataMac!.data()['value'],
                                ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      showDialogCustom("Anda Sudah Login");
                    }
                  } else {
                    showDialogCustom("Mac Anda Sudah Tidak Aktif");
                  }
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text("Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}



// 04:e5:98:36:af:5c