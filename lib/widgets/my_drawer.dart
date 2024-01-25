import 'package:flutter/material.dart';
import 'package:ndp_sushi_restaurant/Authentication/login.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/pages/HistoryScreen.dart';
import 'package:ndp_sushi_restaurant/pages/cart_page.dart';
import 'package:ndp_sushi_restaurant/pages/menu_page.dart';
import '../models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyDrawer extends StatelessWidget {
  User? currentUser = FirebaseAuth.instance.currentUser;
  Users? model;
  BuildContext? context;
  Future<String?> getPhotoUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? photoUrl = sharedPreferences.getString("photoUrl");
    return photoUrl;
  }

  Future<String?> getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userName = sharedPreferences.getString("name");
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return Drawer(
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                          ),

                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Container(
                              width: 100,
                              height: 100,
                              child: FutureBuilder<String?>(
                                future: getPhotoUrl(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage(sharedPreferences?.getString("photoUrl")??""),
                                    );
                                  } else {
                                    return Placeholder(); // Placeholder while loading or handle differently
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          sharedPreferences!.getString("name")??"",
                          //widget.model!.userName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                ),

                SizedBox(height: 12,),

                Container(
                  padding: EdgeInsets.only(top: 1),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.home, color: primaryColor,),
                        title: Text("Home",
                          style: TextStyle(color: Colors.black,),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => MenuPage()));
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.reorder, color: primaryColor,),
                        title: Text("My Cart",
                          style: TextStyle(color: Colors.black,),
                        ),
                        onTap: () {

                          Navigator.push(
                              context, MaterialPageRoute(builder: (c) => CartPage(currentUser: currentUser)));
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.access_time, color: primaryColor,),
                        title: Text(
                          "History",
                          style: TextStyle(color: Colors.black,),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen(currentUser: currentUser)));
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.exit_to_app, color: primaryColor,),
                        title: Text("Sign Out",
                          style: TextStyle(color: Colors.black,),
                        ),
                        onTap: () {
                          firebaseAuth.signOut().then((value) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => LoginScreen()));
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}



