import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/models/food.dart';
import 'package:ndp_sushi_restaurant/pages/food_details_page.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
  class _SearchScreenState extends State<SearchScreen> {

    Future<QuerySnapshot>? foodsDocumentList;
    String foodNames = "";

    initSearchFood(String textEntered) {
      foodsDocumentList = FirebaseFirestore.instance.collection("food")
          .where("foodName", isGreaterThanOrEqualTo: textEntered).get();
    }




    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: TextField(
            onChanged: (value) {
              setState(() {
                foodNames = value;
              });
              initSearchFood(value);
            },
            decoration: InputDecoration(
              hintText: "Search Food here...",
              hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white54
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  initSearchFood(foodNames);
                },
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        body: FutureBuilder(
            future: foodsDocumentList,
            builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Food food = Food.fromJson(
                          snapshot.data!.docs[index]
                        );
                        return FoodDetailsPage(
                          food: food,
                          idFood: '',
                        );
                    }
                ):Center(child: Text("No Recored Fould"),);
            },
        )
      );
    }
  }