import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fetch extends StatelessWidget {
  Fetch({super.key});
  final _firestore = FirebaseFirestore.instance;

  void getfetch() async {
    await for (var snapshot in _firestore.collection('cars').snapshots()) {
      for (var car in snapshot.docs) {
        print(car.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: TextButton(
                onPressed: () {
                  getfetch();
                },
                child: const Text("FETCH")),
          ),
        ),
      ),
    );
  }
}
