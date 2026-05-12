import 'package:flutter/material.dart';
import 'package:mealino/Pages/profile_page.dart';
import 'package:mealino/Services/user_service.dart';

class FoodProfilePage extends StatefulWidget {
  const FoodProfilePage({super.key});

  @override
  State<FoodProfilePage> createState() => _FoodProfileState();
}

class _FoodProfileState extends State<FoodProfilePage>{

  bool halal = false;
  bool vegan = false;

  List<String> selected = [];

  @override
  void initState() {
    super.initState();

    loadPreferences();
  }

  Widget buildSwitchCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconBg,
  required Color activeColor,
  required bool value,
  required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: activeColor),
          ),

          const SizedBox(width: 15), 
     
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }

  Widget buildChip(String label, IconData icon) {
    final isSelected = selected.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selected.remove(label);
          } else {
            selected.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF26A3D) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF26A3D)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF64748B),
            ),

            const SizedBox(width: 6),

            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),

            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> loadPreferences() async {

    try {

      final result =
          await UserService.getPreferences();

      final data = result["data"]["user"];

      setState(() {

        halal =
            data["requiresHalal"] ?? false;

        vegan =
            data["requiresVegan"] ?? false;

        selected = List<String>.from(
          data["allergies"] ?? [],
        );

      });

    } catch(e){

      print(e);

    }

  }

  Future<void> savePreferences() async {

    try {

      final result = await UserService.savePreferences(

        halal: halal,
        vegan: vegan,
        allergies: selected,

      );

      final statusCode = result["statusCode"];

      if(statusCode == 200 ||
          statusCode == 201){

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Preferences Saved",
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProfilePage(),
          ),
        );

      }

    } catch(e){

      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Connection Error",
          ),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,

        title: const Text(
          "Food Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Personalize your recommendations by setting your\ndietary requirements and restrictions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Color(0xFF64748B),
                  ),
                )
              ),

              const SizedBox(height: 35),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Dietary Requirements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 15),

                  buildSwitchCard(
                    title: "Halal Only", 
                    subtitle: "Strictly exclude non-halal items", 
                    icon: Icons.check_circle, 
                    iconBg: const Color(0xFFFFE5DC), 
                    activeColor: const Color(0xFFF26A3D), 
                    value: halal, 
                    onChanged: (val){
                      setState((){
                        halal = val;
                      });
                    },
                  ),

                  buildSwitchCard(
                    title: "Vegan", 
                    subtitle: "Plant-based diet only", 
                    icon: Icons.eco, 
                    iconBg: const Color(0xFFE6F7EC), 
                    activeColor: Colors.green, 
                    value: vegan, 
                    onChanged: (val){
                      setState((){
                        vegan = val;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allergies & Intolerances",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B), 
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selected.clear();
                      });
                    },
                    child: Text(
                      "Clear all",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF26A3D),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  buildChip("Seafood", Icons.set_meal),
                  buildChip("Peanut", Icons.circle),
                  buildChip("Dairy", Icons.local_drink),
                  buildChip("Gluten", Icons.ramen_dining),
                  buildChip("Soy", Icons.eco),
                  buildChip("Eggs", Icons.egg),
                  buildChip("Sesame", Icons.grain),
                  buildChip("Wheat", Icons.grass),
                ],
              ),

              const SizedBox(height: 290),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: savePreferences,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26A3D),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Save Preferences",
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