
import 'package:flutter/material.dart';
import 'package:mealino/Pages/change_name_page.dart';
import 'package:mealino/Pages/food_profile_page.dart';
import 'package:mealino/Pages/update_password_page.dart';
import 'package:mealino/Pages/welcome_page.dart';

class ProfileContentPage extends StatelessWidget {
  const ProfileContentPage({super.key});

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isLogout
                    ? const Color(0xFFFFE5E5)
                    : const Color(0xFFFFE5DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isLogout
                    ? Colors.red
                    : const Color(0xFFF26A3D),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLogout
                          ? Colors.red
                          : const Color(0xFF111827),
                    ),
                  ),

                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFF94A3B8),
            )
          ],
        ),
      ),
    );
  }

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
              const SizedBox(height: 20),
              
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF26A3D),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: Column(
                  children: const [
                    SizedBox(height: 10),

                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Name@sunib.ac.id',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),

                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              const Text(
                'Account Settings',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 248, 250, 252),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),

                child: Column(
                  children: [
                    buildMenuItem(
                      icon: Icons.person_outline, 
                      title: "Change Name",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeNamePage() 
                          ),
                        );
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: Color(0xFFE2E8F0),
                    ),

                    buildMenuItem(
                      icon: Icons.restaurant, 
                      title: "Food Profile",
                      subtitle: "Dietary requirements & allergies",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FoodProfilePage() 
                          ),
                        );
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: Color(0xFFE2E8F0),
                    ),

                    buildMenuItem(
                      icon: Icons.lock_outline, 
                      title: "Update Password",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdatePasswordPage() 
                          ),
                        );
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: Color(0xFFE2E8F0),
                    ),

                    buildMenuItem(
                      icon: Icons.logout, 
                      title: "Log Out",
                      isLogout: true,
                      onTap: () {
                          showDialog(
                            context: context, 
                            barrierDismissible: true,
                            builder: (context){
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFFFE5DC),
                                        ),
                                        child: const Icon(
                                          Icons.logout,
                                          color: Color(0xFFF26A3D),
                                          size: 30,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      const Text(
                                        "Log Out",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      const Text(
                                        "Are you sure you want to log out?\nYou will need to enter your\ncredentials to log back in.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),

                                      const SizedBox(height: 25),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const WelcomePage(), 
                                              )
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFF26A3D),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: const Text(
                                            'Log Out',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),   
                                          ),
                                      ),

                                      const SizedBox(height: 12),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFE5E7EB),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      },
                    ),
                  ],
                ),
              )
            ],
          ), 
        )      
      ),
    );
  }
}