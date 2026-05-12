import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealino/Services/food_service.dart';

import 'package:mealino/Models/restaurant_model.dart';
import 'package:mealino/Widgets/restaurant_card.dart';

class FoodResultPage extends StatefulWidget {
  final double radius;

  final int minPrice;
  final int maxPrice;

  final String mood;

  const FoodResultPage({
    super.key,

    required this.radius,

    required this.minPrice,
    required this.maxPrice,

    required this.mood,
  });

  @override
  State<FoodResultPage> createState() =>
      _FoodResultState();
}

class _FoodResultState
    extends State<FoodResultPage> {

  List<RestaurantModel> restaurantList = [];

  String selectedSort = "Relevance";

  @override
  void initState() {
    super.initState();

    loadRestaurants();
  }

  Future<void> loadRestaurants() async {

    restaurantList =
        await FoodService.getRecommendations(

      mood: widget.mood,

      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,

      radius: widget.radius,
    );

    setState(() {});
  }

  void sortRestaurants(String type) {

    setState(() {

      selectedSort = type;

      if (type == "Rating") {

        restaurantList.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );

      } else if (type == "Price") {

        restaurantList.sort(
          (a, b) => a.startingPrice.compareTo(
            b.startingPrice,
          ),
        );

      } else if (type == "Relevance") {

        restaurantList.shuffle();
      }
    });
  }

  Widget sortButton(String title) {

    bool isSelected =
        selectedSort == title;

    return GestureDetector(

      onTap: () {
        sortRestaurants(title);
      },

      child: Container(
        margin:
            const EdgeInsets.only(right: 20),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? const Color(0xFFF26A3D)
              : Colors.grey.shade100,

          borderRadius:
              BorderRadius.circular(30),

          border: Border.all(

            color: isSelected
                ? const Color(0xFFF26A3D)
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          title,

          style: TextStyle(

            color: isSelected
                ? Colors.white
                : Colors.black87,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        backgroundColor: Colors.white,

        centerTitle: true,

        title: const Text(
          "Top Picks",

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 28,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              Row(
                children: [

                  Text(
                    "Sort by:",

                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey.shade600,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 20),

                  sortButton("Relevance"),

                  sortButton("Rating"),

                  sortButton("Price"),
                ],
              ),

              const SizedBox(height: 20),

              Text(

                restaurantList.length > 1
                    ? '${restaurantList.length} Matches'
                    : '${restaurantList.length} Match',

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(

                child: restaurantList.isEmpty

                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )

                    : ListView(

                        children:
                            restaurantList.map(

                          (restaurant) {

                            return RestaurantCard(
                              restaurant:
                                  restaurant,
                            );
                          },

                        ).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}