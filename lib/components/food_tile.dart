import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndp_sushi_restaurant/models/food.dart';


class FoodTile extends StatelessWidget {
  final Food? food;
  BuildContext? context;
  final void Function()? onTap;

  FoodTile({
    super.key,
    required this.food,
    required this.context,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //image
            Center(
              child: Image.network(
                food!.foodImagePath!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),

            // text
            Text(
              food!.foodName!,
              style: GoogleFonts.dmSerifDisplay(fontSize: 20),
            ),

            // price + rating
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //price
                  Text(
                    '\$ ${food!.foodPrice!}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),

                  // rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[800],
                      ),
                      Text(
                        food!.foodRating!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
