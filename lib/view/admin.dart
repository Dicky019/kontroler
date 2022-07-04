import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kontroler/model/mac_model.dart';

import '../widgets/button/button.dart';
import '../widgets/state_home/loading.dart';
import '../widgets/state_home/error.dart';
import 'login.dart';

class Admin extends StatelessWidget {
  final String id;
  const Admin({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final valueC = TextEditingController();

    Future<void> addData(BuildContext context) async {
      Widget add = TextField(
        controller: valueC,
        decoration: const InputDecoration(hintText: "mac"),
      );

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Data'),
            content: add,
            actions: <Widget>[
              ButtonOff(
                title: 'Add',
                onPressed: () async {
                  await firestore.collection('mac').add(
                        MacUsers(
                                id: "",
                                isLogin: false,
                                isAdmin: false,
                                isActive: false,
                                value: valueC.text)
                            .toJson(),
                      );
                  valueC.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
              ButtonOff(
                title: 'Cancel',
                onPressed: () {
                  valueC.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        // leading:
        backgroundColor: Colors.lightBlue[300],
        title: const Text("Admin"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await firestore.collection('mac').doc(id).update(
                {
                  "isLogin": false,
                },
              );
              var box = GetStorage();
              box.remove(
                'isLogin',
              );
              box.remove(
                'isAdmin',
              );
              box.remove(
                'mac',
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                return AdminSuccess(listData: listData, firestore: firestore);
              } else {
                return const Text('Empty data');
              }
            }
            return Text('State: ${snapshot.connectionState}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue[300],
          onPressed: () {
            addData(context);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class AdminSuccess extends StatelessWidget {
  const AdminSuccess({
    Key? key,
    required this.listData,
    required this.firestore,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    final valueC = TextEditingController();

    Future<void> editData(BuildContext context, String id) async {
      Widget add = TextField(
        controller: valueC,
        decoration: const InputDecoration(hintText: "mac"),
      );

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Data'),
            content: add,
            actions: <Widget>[
              ButtonOff(
                title: 'Edit',
                onPressed: () async {
                  await firestore.collection('mac').doc(id).update(
                    {"value": valueC.text},
                  );
                  valueC.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
              ButtonOff(
                title: 'Cancel',
                onPressed: () {
                  valueC.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> choised(BuildContext context, String id, String value) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Choise Data')),
            // content: add,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonOff(
                  title: 'Edit Data',
                  onPressed: () {
                    Navigator.pop(context);
                    valueC.text = value;
                    editData(context, id);
                  },
                ),
                ButtonOff(
                  title: 'Delete Data',
                  onPressed: () async {
                    await firestore.collection('mac').doc(id).delete();
                    valueC.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            // actions: <Widget>[

            // ],
          );
        },
      );
    }

    var listDataUser = listData
        .where((element) => element.data()['isAdmin'] == false)
        .toList();

    var c = Get.put(MyController());

    return ListView.builder(
      itemCount: listDataUser.length,
      itemBuilder: (context, index) {
        var data = listDataUser[index];
        return Column(
          children: [
            if (index == 0)
              ListTile(
                title: const Text(
                  "Matikan Semua",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Obx(
                  () => Checkbox(
                    activeColor: Colors.lightBlue[300],
                    value: c.matikanSemua.value,
                    onChanged: (value) async {
                      c.matikanSemua.value = value ?? true;
                      // ignore: avoid_function_literals_in_foreach_calls
                      listDataUser.forEach((element) async {
                        await firestore
                            .collection('mac')
                            .doc(element.id)
                            .update(
                          {
                            'isActive': false,
                          },
                        );
                      });
                    },
                  ),
                ),
              ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue[300],
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () async =>
                  await choised(context, data.id, data.data()['value']),
              trailing: Checkbox(
                activeColor: Colors.lightBlue[300],
                value: data.data()['isActive'],
                onChanged: (value) async {
                  c.matikanSemua.value = false;
                  // ignore: avoid_function_literals_in_foreach_calls
                  listDataUser.forEach((element) async {
                    await firestore.collection('mac').doc(element.id).update(
                      {
                        'isActive': false,
                      },
                    );
                  });
                  await firestore.collection('mac').doc(data.id).update(
                    {
                      'isActive': true,
                    },
                  );
                },
              ),
              title: Text(
                data.data()['value'],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyController extends GetxController {
  var matikanSemua = false.obs;
}
