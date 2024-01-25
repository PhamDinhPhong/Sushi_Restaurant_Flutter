import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/models/shop.dart';
import 'package:provider/provider.dart';
import '../components/button.dart';
import '../models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  final User? currentUser;
  const CartPage({super.key,this.currentUser});

  void removeFromCart(Map<String, dynamic> document, BuildContext context) async {
    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to remove ${document['foodName']}?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Do not delete
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm delete
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .collection('Cart')
            .doc(document['idCart'])
            .delete();
      }
    } catch (error) {
      print("Error removing from cart: $error");
    }
  }

  Future<void> payNow(BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance.collection("users").doc(currentUser?.uid).collection("Cart").get();

      String timestamp = DateTime.now().toUtc().toString();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      cartSnapshot.docs.forEach((DocumentSnapshot cartDocument) {
        Map<String, dynamic> cartData = cartDocument.data() as Map<String, dynamic>;

        // Kiểm tra xem bạn có muốn giữ tài liệu này trong "Cart" không
        if (shouldKeepInCart(cartData)) {
          // Nếu có, cập nhật tài liệu trong bộ sưu tập "Cart" với các trường mới hoặc giữ nguyên như cũ
          batch.set(
            cartDocument.reference,
            {
              "fieldToUpdate": "updatedValue", // Thêm trường mới hoặc cập nhật các trường hiện có
            },
            SetOptions(merge: true), // Sử dụng tùy chọn merge để giữ lại các trường hiện có
          );
        } else {
          // Nếu không, chuyển tài liệu sang bộ sưu tập "History"
          batch.set(
            FirebaseFirestore.instance.collection("users").doc(currentUser?.uid).collection("History").doc(cartDocument.id),
            {
              "foodUID": cartData['foodUID'],
              "foodImagePath": cartData['foodImagePath'],
              "foodName": cartData['foodName'],
              "quantity": cartData['quantity'],
              "totalPrice": cartData['totalPrice'],
              "historyID": cartDocument.id,
            },
          );

          // Xóa tài liệu khỏi "Cart"
          batch.delete(cartDocument.reference);
        }
      });

      // Thực hiện ghi tất cả các thay đổi cùng một lúc
      await batch.commit();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: const Text(
            "Thanh toán thành công!",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    } catch (error) {
      print("Lỗi xử lý thanh toán: $error");
    }
  }

  bool shouldKeepInCart(Map<String, dynamic> cartData) {
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, value, child) =>
          Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              title: const Text("My Cart"),
              backgroundColor: primaryColor,
            ),
            body: StreamBuilder (
              stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('Cart').snapshots(),
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
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => removeFromCart(document, context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: MyButton(
                        text: "Pay Now",
                        onTap: () => payNow(context),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
    );
  }
}