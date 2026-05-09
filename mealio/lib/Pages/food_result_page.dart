import 'package:flutter/material.dart';

class FoodResultPage extends StatefulWidget {
  const FoodResultPage({super.key});

  @override
  State<FoodResultPage> createState() => _FoodResultState();
}

class _FoodResultState extends State<FoodResultPage> {
  Widget restaurantCard({
    required String imageUrl,
    required String name,
    required String category,
    required double rating,
    required String price,
    required String distance,
    required int matchPercent,
    required String matchComment,
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
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EE),
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF26A3D),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              '$matchPercent% MATCH',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF26A3D),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '"$matchComment"',
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String selectedSort = "Null";

  Widget sortButton(String title) {

    bool isSelected = selectedSort == title;

    return GestureDetector(

      onTap: () {
        setState(() {
          selectedSort = title;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 20),

        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF26A3D)
              : Colors.grey.shade100,

          borderRadius: BorderRadius.circular(30),

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

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultList = [

      restaurantCard(
        imageUrl: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624",
        name: "Ramen Nagi",
        category: "Japanese - Ramen - Noodles",
        rating: 4.5,
        price: "From 15k",
        distance: "0.8 km",
        matchPercent: 88,
        matchComment: "A solid comfort food option nearby, though a bit heavier than your usual lunch."
      ),

      restaurantCard(
        imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
        name: "Sushi Hiro",
        category: "Japanese - Sushi",
        rating: 4.8,
        price: "From 25k",
        distance: "1.2 km",
        matchPercent: 80,
        matchComment: "Comfort fod"
      ),
    ];

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
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    "Sort by:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 20),

                  sortButton("Relevance"),
                  sortButton("Distance"),
                  sortButton("Rating"),
                ]
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [              
                  
                  Text(
                    resultList.length > 1
                      ? '${resultList.length} Matches'
                      : '${resultList.length} Match',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView(
                  children: resultList,
                )
              )
            ],
          ),
        ) 
      
      )
    );
  }

}

  
