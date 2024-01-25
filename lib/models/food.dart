import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String? foodUID;
  final String foodName;
  final String foodPrice;
  final String foodImagePath;
  final String foodRating;
  final String foodDescription;


  const Food({
    this.foodUID,
    required this.foodName,
    required this.foodPrice,
    required this.foodImagePath,
    required this.foodRating,
    required this.foodDescription,
  });


  // Food.fromJson(Map<String, dynamic> json) {
  //   foodUID = json["foodUID"];
  //   foodName = json["foodName"];
  //   foodPrice = json["foodPrice"];
  //   foodImagePath = json["foodImagePath"];
  //   foodRating = json["foodRating"];
  //   foodDescription = json["foodDescription"];
  // }

  toJson() {
    return {
      "foodUID": foodUID,
      "foodName": foodName,
      "foodPrice": foodPrice,
      "foodImagePath": foodImagePath,
      "foodRating": foodRating,
      "foodDescription": foodDescription
    };
    // data["foodUID"] = foodUID;
    // data["foodName"] = foodName;
    // data["foodPrice"] = foodPrice;
    // data["foodImagePath"] = foodImagePath;
    // data["foodRating"] = foodRating;
    // data["foodDescription"] = foodDescription;
    // return data;
  }


  factory Food.fromJson(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return Food(
      foodUID: document.id,
      foodName: data["foodName"],
      foodPrice: data["foodPrice"],
      foodImagePath: data["foodImagePath"],
      foodRating: data["foodRating"],
      foodDescription: data["foodDescription"],
    );
  }

}
