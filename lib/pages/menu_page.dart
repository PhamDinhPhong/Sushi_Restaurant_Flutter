import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndp_sushi_restaurant/components/button.dart';
import 'package:ndp_sushi_restaurant/components/food_tile.dart';
import 'package:ndp_sushi_restaurant/components/search_screen.dart';
import 'package:ndp_sushi_restaurant/global/global.dart';
import 'package:ndp_sushi_restaurant/models/food.dart';
import 'package:ndp_sushi_restaurant/pages/food_details_page.dart';
import 'package:ndp_sushi_restaurant/widgets/my_drawer.dart';
import 'package:ndp_sushi_restaurant/widgets/progress_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../models/shop.dart';

class MenuPage extends StatefulWidget {
  Food? food;
  BuildContext? context;

  MenuPage({
    super.key,
    this.food,
    this.context,
  });


  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  // void navigateToFoodDetails(int index) {
  //   final shop = context.read<Shop>();
  //   final foodMenu = shop.foodMenu;
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => FoodDetailsPage(
  //       food: foodMenu[index],
  //       // Food: null,
  //     ),),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final Food food;
    // final shop = context.read<Shop>();
    // final foodMenu = shop.foodMenu;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("NDP RESTAURANT",
          style: TextStyle(
            fontSize: 17.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Row(
            children: [

              // IconButton(onPressed: () {},
              //     icon: const Icon(FontAwesomeIcons.shoppingCart)
              // ),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => SearchScreen() ));
              },
                  icon: Icon(Icons.search),
              ),



            ],

          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 9,),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 9,),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Get 32% Promo",
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    MyButton(text: "Redeem", onTap: () {})
                  ],
                ),

                SizedBox(width: 1,),

                Image.asset(
                  'images/sushi (1).png',
                  height: 90,
                  width: 90,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Food Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("food").snapshots(),
              builder: (context, snapshot) {

                return (!snapshot.hasData)
                    ? Center(
                  child: circularProgress(),
                )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Food sModel = Food.fromJson(
                            snapshot.data!.docs[index]
                          );
                          return FoodTile(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => FoodDetailsPage(
                                food: widget.food ,
                                context: context,
                                idFood: sModel.foodUID,
                              )
                              )
                              );

                            }
                            // => navigateToFoodDetails(index)
                            ,
                            food: sModel,
                            context: context,
                          );
                        },
                );
              },
            ),
          ),


          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(left: 9, right: 9, bottom: 9),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // image
                    Image.asset(
                      'images/sushi.png',
                      height: 60,
                    ),

                    const SizedBox(width: 20),

                    // name and price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name
                        Text(
                          "Salmon Eggs",
                          style: GoogleFonts.dmSerifDisplay(fontSize: 18),
                        ),

                        const SizedBox(height: 10),

                        // price
                        Text(
                          '\$20.00',
                          style: TextStyle(color: Colors.grey[700]),
                        )
                      ],
                    ),
                  ],
                ),

                // heart
                const Icon(
                  Icons.favorite_outline,
                  color: Colors.grey,
                  size: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
