import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/models/shop.dart';
import 'package:provider/provider.dart';
import '../components/button.dart';
import '../models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  final User? currentUser;
  const HistoryScreen({super.key,this.currentUser});





  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, value, child) =>
          Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              title: const Text("My History"),
              backgroundColor: primaryColor,
            ),
            body: StreamBuilder (
              stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('History').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // Dữ liệu được truy vấn từ Firebase
                final cartDocuments = snapshot.data!.docs;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartDocuments.length,
                        itemBuilder: (context, index) {
                          // final Food food = value.cart[index];
                          final document = cartDocuments[index].data() as Map<String, dynamic>;
                          // final String foodUID = document['foodUID'] ?? '';
                          final String foodName = document['foodName'] ?? '';
                          final String foodImagePath = document['foodImagePath'] ?? '';
                          final double totalPrice = (document['totalPrice'] ?? 0.0).toDouble();


                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.only(
                              left: 20,
                              top: 20,
                              right: 20,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Image.network(
                                    foodImagePath,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                // ListTile để hiển thị thông tin còn lại
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      foodName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          totalPrice.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 59,),
                                        Text(
                                          document['quantity'].toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
    );
  }
}