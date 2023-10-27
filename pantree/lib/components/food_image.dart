import 'package:flutter/material.dart';
import 'package:pantree/services/foodService.dart';  
/*
  this class was created so that when we would like the image of the given food item
  all we need to is provide the foodId and it will return the image link from the 
  database and we can then grab it from the internet

*/
class FoodImage extends StatelessWidget {
  final String foodId;
  final double size;
  final double borderRadius;
  final FoodService foodService = FoodService();
  
  FoodImage({super.key, 
    required this.foodId,
    this.size = 100.0, // default value
    this.borderRadius = 8, // default value
  });

  Future<String?> getFoodImageLink() async {
    return await foodService.fetchFoodImageLink(foodId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getFoodImageLink(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError){
            return Container(
              width: size,
              height: size,
              color: Colors.red,
            );
          } else if (snapshot.hasData) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: NetworkImage(snapshot.data!), 
                  fit: BoxFit.cover),
              ),
            );
          } else {
            // Handle error or display a placeholder
            return Container(width: size, height: size, color: Colors.grey);
          }
        } else {
          // Show a loader while fetching the image
          return SizedBox(width: size, height: size, child: const CircularProgressIndicator());
        }
      },
    );
  }
}