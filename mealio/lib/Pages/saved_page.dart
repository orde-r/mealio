import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  List restaurants = [];

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Future<void> getFavorites() async {

    try {

      final prefs =
          await SharedPreferences.getInstance();

      final token = prefs.getString("token");

      final response = await http.get(

        Uri.parse(
          'http://localhost:3000/api/user/favorites',
        ),

        headers: {
          "Authorization": "Bearer $token",
        },

      );

      final data = jsonDecode(response.body);

      if(response.statusCode == 200){

        setState(() {
          restaurants = data;
        });

      }

    } catch(e){

      print(e);

    }

  }

  Future<void> removeFavorite(
    String restaurantId,
  ) async {

    try {

      final prefs =
          await SharedPreferences.getInstance();

      final token = prefs.getString("token");

      final response = await http.delete(

        Uri.parse(
          'http://localhost:3000/api/user/favorites/$restaurantId',
        ),

        headers: {
          "Authorization": "Bearer $token",
        },

      );

      if(response.statusCode == 200){

        getFavorites();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Removed from favorites",
            ),
          ),
        );

      }

    } catch(e){

      print(e);

    }

  }

  Widget restaurantCard({

    required String id,
    required String imageUrl,
    required String name,
    required String category,
    required double rating,
    required String price,
    required String distance,

  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Stack(
            children: [

              ClipRRect(

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),

                child: Image.network(
                  imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 16,
                right: 16,

                child: GestureDetector(

                  onTap: () {
                    removeFavorite(id);
                  },

                  child: Container(
                    width: 42,
                    height: 42,

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFF26A3D),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Expanded(
                      child: Text(
                        name,

                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),

                    Container(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: const [

                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.black54,
                          ),

                          SizedBox(width: 4),

                          Text(
                            'Open',

                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  category,

                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Row(
                      children: [

                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          rating.toString(),

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          '•',

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade400,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          price,

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          '•',

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade400,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          distance,

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      'View Map →',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF26A3D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        automaticallyImplyLeading: false,

        title: const Text(
          "Favorites",

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Saved Places',

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Text(

                    restaurants.length > 1
                      ? '${restaurants.length} Items'
                      : '${restaurants.length} Item',

                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(

                child: restaurants.isEmpty

                  ? const Center(
                      child: Text(
                        "No Favorite Restaurant",
                      ),
                    )

                  : ListView.builder(

                      itemCount: restaurants.length,

                      itemBuilder: (context, index) {

                        final restaurant =
                            restaurants[index];

                        return restaurantCard(

                          id: restaurant["id"],

                          imageUrl:
                              restaurant["imageUrl"],

                          name:
                              restaurant["name"],

                          category:
                              restaurant["tags"]
                                  .join(" • "),

                          rating:
                              restaurant["rating"]
                                  .toDouble(),

                          price:
                              "From ${restaurant["startingPrice"]}k",

                          distance:
                              "0.8 km",
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}