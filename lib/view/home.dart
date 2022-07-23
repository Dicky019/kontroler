import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../widgets/state/home/success.dart';
import '../widgets/state/error.dart';
import '../widgets/state/loading.dart';

// ignore_for_file: use_build_context_synchronously
class Home extends StatelessWidget {
  final String mac;
  const Home({super.key, required this.mac});
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference starCountRef = database.ref();
    // String? isLogin = box.read('isLogin');

    return Scaffold(
      appBar: AppBar(
        // leading:
        backgroundColor: Colors.lightBlue[300],
        title: const Text("Kontroler"),
        centerTitle: true,
       
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Error();
              } else if (snapshot.hasData) {
                var data = snapshot.data?.snapshot.value as Map;
                return HomeSucess(
                  data: data,
                  starCountRef: starCountRef,
                  
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
