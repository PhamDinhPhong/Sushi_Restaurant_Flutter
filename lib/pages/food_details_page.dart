import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndp_sushi_restaurant/models/shop.dart';
import 'package:provider/provider.dart';
import '../components/button.dart';
import '../global/global.dart';
import '../models/food.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodDetailsPage extends StatefulWidget {
  final Food? food;
  final BuildContext? context;
  final String? idFood;

  const FoodDetailsPage({
    super.key,
    this.food,
    this.context,
    required this.idFood,
  });

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int quantityCount = 0;
  late Food foodModel;

  void decrementQuantity() {
    setState(() {
      if (quantityCount > 0) {
        quantityCount--;
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  Future<void> addToCart() async {
    if (quantityCount > 0) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      double foodPrice = double.parse(foodModel.foodPrice!);
      try {
        // Thực hiện thêm dữ liệu vào Firestore
        DocumentReference cartDocumentReference = await FirebaseFirestore.instance.collection("users").doc(currentUser?.uid).collection("Cart").add({
          "foodUID": foodModel.foodUID!,
          "foodImagePath": foodModel.foodImagePath!,
          "foodName": foodModel.foodName!,
          "quantity": quantityCount,
          "totalPrice": quantityCount * foodPrice,
          "idCart": "",
        });

        String idCart = cartDocumentReference.id;
        await cartDocumentReference.update({"idCart": idCart});

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: const Text(
              "Successfully added to cart",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
        print("Error adding to cart: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("food")
            .where("foodUID", isEqualTo: widget.idFood)
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          foodModel = Food.fromJson(snapshots.data!.docs.first);

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ListView(
                    children: [
                      Image.network(
                        foodModel.foodImagePath,
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            foodModel.foodRating,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        foodModel.foodName,
                        style: GoogleFonts.dmSerifDisplay(fontSize: 28),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        foodModel.foodDescription,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: primaryColor,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${foodModel.foodPrice}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                onPressed: decrementQuantity,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(
                                  quantityCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: incrementQuantity,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      text: "Add To Cart",
                      onTap: addToCart,
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
