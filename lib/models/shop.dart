import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ndp_sushi_restaurant/models/food.dart';

class Shop extends ChangeNotifier {
  CollectionReference _foodCollection = FirebaseFirestore.instance.collection('food');

  List<Food> _foodMenu = [];
  List<Food> _cart = [];

  List<Food> get foodMenu => _foodMenu;
  List<Food> get cart => _cart;

  // Hàm này sẽ tải danh sách thực phẩm từ Firebase
  Future<void> loadFoodMenu() async {
    QuerySnapshot foodSnapshot = await _foodCollection.get();
    _foodMenu = foodSnapshot.docs.map((doc) => Food.fromJson(doc)).toList();
    notifyListeners();
  }

  // Hàm này sẽ thêm một món ăn vào giỏ hàng
  void addToCart(Food foodItem, int quantity) {
    for (int i = 0; i < quantity; i++) {
      _cart.add(foodItem);
    }
    notifyListeners();
  }

  // Hàm này sẽ xóa một món ăn khỏi giỏ hàng
  void removeFromCart(Food food) {
    _cart.remove(food);
    notifyListeners();
  }
}
