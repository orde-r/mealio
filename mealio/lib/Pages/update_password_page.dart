import 'package:flutter/material.dart';
import 'package:mealino/Services/user_service.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePasswordPage> {

  bool isCurrentPasswordHidden = true;
  bool isNewPasswordHidden = true;
  bool isConfirmNewPasswordHidden = true; 

  final TextEditingController oldPasswordController =
    TextEditingController();

  final TextEditingController newPasswordController =
      TextEditingController();

  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  Future<void> updatePassword() async {

    if(newPasswordController.text !=
        confirmNewPasswordController.text){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Password does not match",
          ),
        ),

      );

      return;
    }

    try {

      final result =
          await UserService.updatePassword(

        oldPassword:
            oldPasswordController.text,

        newPassword:
            newPasswordController.text,

      );

      final statusCode =
          result["statusCode"];

      final data =
          result["data"];

      if(statusCode == 200){

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Password Updated",
            ),
          ),

        );

        Navigator.pop(context);

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              data["message"] ??
                  "Update Failed",
            ),
          ),

        );

      }

    } catch(e){

      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(

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
          'Update Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black 
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 25),

              const Text(
                "Update Password",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                "Please enter your current password and choose a new one to secure your account",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Current Password",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: oldPasswordController,

                obscureText: isCurrentPasswordHidden,

                decoration: InputDecoration(
                  hintText: "Input Current Password",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),

                  suffixIcon: IconButton(

                    icon: Icon(
                      isCurrentPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),

                    onPressed: () {

                      setState(() {
                        isCurrentPasswordHidden = !isCurrentPasswordHidden;
                      });

                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "New Password",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: newPasswordController,

                obscureText: isNewPasswordHidden,

                decoration: InputDecoration(
                  hintText: "Input New Password",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),

                  suffixIcon: IconButton(

                    icon: Icon(
                      isNewPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),

                    onPressed: () {

                      setState(() {
                        isNewPasswordHidden = !isNewPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Must be at least 8 characters long.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Confirm New Password",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: confirmNewPasswordController,

                obscureText: isConfirmNewPasswordHidden,

                decoration: InputDecoration(
                  hintText: "Input Confirm New Password",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),

                  suffixIcon: IconButton(

                    icon: Icon(
                      isConfirmNewPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),

                    onPressed: () {

                      setState(() {
                        isConfirmNewPasswordHidden = !isConfirmNewPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 290),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: updatePassword,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26A3D),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Update Password",
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