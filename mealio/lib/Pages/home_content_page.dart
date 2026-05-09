import 'package:flutter/material.dart';
import 'package:mealino/Pages/food_result_page.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentState(); 
}

class _HomeContentState extends State<HomeContentPage>{
  final List<int> priceOptions = [10,30,50,100,300];

  String formatRange(int start, int end) {
    if (start == end) {
      return formatPrice(start); // cuma 1 angka
    }
    return "${formatPrice(start)} - ${formatPrice(end)}";
  }

  String formatPrice(int value) {
    if (value == 300) {
      return "300k+";
    }
    return "${value}k";
  }

  double radius = 5;
  RangeValues priceRangeIndex = const RangeValues(0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              const Text(
                'Hungry, Name?',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'What are you\ncraving today?',
                style: TextStyle(
                  fontSize: 42,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                minLines: 4,
                maxLines: null,

                decoration: InputDecoration(
                  hintText: "i want something... (e.g., spicy and warm\nbecause it's raining)",
                  hintStyle: TextStyle(
                    color: Color(0xFF64748B),
                  ),

                  filled: true,
                  fillColor: const Color.fromARGB(255, 248, 248, 248),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5, 
                  )
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Color(0xFFF26A3D)),
                            SizedBox(width: 6),
                            Text(
                              "Search Radius",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "${radius.toInt()} km",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFF26A3D),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFFF26A3D),
                        overlayColor: const Color(0xFFF26A3D).withOpacity(0.2),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: radius,
                        min: 1,
                        max: 15,
                        divisions: 3,
                        onChanged: (value) {
                          setState(() {
                            radius = value;
                          });
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("1km", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("5km", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("10km", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("15km", style: TextStyle(color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5, 
                  )
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: const [
                            Icon(Icons.attach_money, color: Color(0xFFF26A3D)),
                            SizedBox(width: 6),
                            Text(
                              "Pricing",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          formatRange(
                            priceOptions[priceRangeIndex.start.toInt()],
                            priceOptions[priceRangeIndex.end.toInt()],  
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFF26A3D),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFFF26A3D),
                        overlayColor: const Color(0xFFF26A3D).withOpacity(0.2),
                        trackHeight: 6,
                      ),
                      child: RangeSlider(
                        values: priceRangeIndex,
                        min: 0,
                        max: (priceOptions.length - 1).toDouble(),
                        divisions: priceOptions.length - 1,
                        onChanged: (values) {
                          setState(() {
                            priceRangeIndex = RangeValues(
                              values.start.roundToDouble(),
                              values.end.roundToDouble(),
                            );
                          });
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("10k", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("30k", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("50k", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("100k", style: TextStyle(color: Color(0xFF94A3B8))),
                        Text("300k+", style: TextStyle(color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 180),
              
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FoodResultPage(), 
                      )
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26A3D),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Find My Food",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
          
          ) 
      )
    );
  }
  
}