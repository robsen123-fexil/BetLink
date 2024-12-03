// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class Carlist extends StatelessWidget {
  const Carlist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CARLIST"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CarStream(),
        ),
      ),
    );
  }
}

class CarStream extends StatelessWidget {
  const CarStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('cars').orderBy('timeStamp',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cars = snapshot.data?.docs;
          List<Bubblecars> bubblecar = [];
          for (var car in cars!) {
            final data = car.data();
            final String model = data['model'];
            final String price = data['price'];
            final String place = data['place'];
            final String seats = data['seats'];
            final String imageUrl = data['imageUrl'];

            final bubble = Bubblecars(
              models: model,
              places: place,
              prices: price,
              seats: seats,
              imageUrl: imageUrl,
            );
            bubblecar.add(bubble);
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              mainAxisSpacing: 10, // Space between rows
              crossAxisSpacing: 10, // Space between columns
              childAspectRatio: 0.8, // Adjust to fit your layout
            ),
            itemCount: bubblecar.length,
            
            itemBuilder: (context, index) {
              return bubblecar[index]; // Display each car bubble
            },
          );
        } else {
          return Center(
            child: Text("Fetch is not successful"),
          );
        }
      },
    );
  }
}

class Bubblecars extends StatelessWidget {
  final String models;
  final String prices;
  final String places;
  final String seats;
  final String imageUrl;

  const Bubblecars({
    super.key,
    required this.imageUrl,
    required this.models,
    required this.places,
    required this.prices,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ), // Display placeholder if imageUrl is empty
              ),
            ),
            SizedBox(height: 8),
            Text(
              models,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 5),
                Text(
                  places,
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.blue),
                    SizedBox(width: 5),
                    Text(
                      seats,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.price_check, color: Colors.blue),
                    SizedBox(width: 5),
                    Text(
                      '\$$prices',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
