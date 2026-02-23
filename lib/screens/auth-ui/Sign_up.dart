import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/signup_controller.dart';
import 'package:grocery/screens/auth-ui/Sign_in.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignupController signupController = Get.put(SignupController());

  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    userEmail.dispose();
    userPhone.dispose();
    userCity.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Appconstant.appmaincolor,
            title: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                isKeyboardVisible
                    ? SizedBox.shrink()
                    : Lottie.asset(
                  'assets/images/Sign_in.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),

                /// EMAIL FIELD
                buildTextField(
                  controller: userEmail,
                  hint: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                /// USERNAME FIELD
                buildTextField(
                  controller: username,
                  hint: "Username",
                  icon: Icons.person_2,
                ),

                /// PHONE FIELD
                buildTextField(
                  controller: userPhone,
                  hint: "Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                ),

                /// CITY FIELD (Previously Missing)
                buildTextField(
                  controller: userCity,
                  hint: "City",
                  icon: Icons.location_city,
                ),

                /// PASSWORD FIELD
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                          () => TextFormField(
                        controller: userPassword,
                        obscureText: !signupController.isPasswordVisible.value,
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signupController.isPasswordVisible.toggle();
                            },
                            child: signupController.isPasswordVisible.value
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                          contentPadding:
                          const EdgeInsets.only(top: 2, left: 8),
                          hintStyle:
                          const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// SIGN UP BUTTON
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        String name = username.text.trim();
                        String email = userEmail.text.trim();
                        String phone = userPhone.text.trim();
                        String city = userCity.text.trim();
                        String password = userPassword.text.trim();
                        String userdevicetoken = '';

                        if (name.isEmpty ||
                            email.isEmpty ||
                            phone.isEmpty ||
                            city.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter all details",
                            snackPosition:
                            SnackPosition.BOTTOM,
                            backgroundColor:
                            Appconstant.appSecondaryColor,
                            colorText:
                            Appconstant.appTextColor,
                          );
                          return;
                        }

                        UserCredential? userCredential =
                        await signupController.signUpMethod(
                          name,
                          email,
                          phone,
                          city,
                          password,
                          userdevicetoken,
                        );

                        if (userCredential != null) {
                          Get.snackbar(
                            "Verification email sent.",
                            "Please check your email.",
                            snackPosition:
                            SnackPosition.BOTTOM,
                            backgroundColor:
                            Appconstant.appSecondaryColor,
                            colorText:
                            Appconstant.appTextColor,
                          );

                          await FirebaseAuth.instance.signOut();
                          Get.offAll(() => SignIn());
                        }
                      },
                      icon: const Icon(
                        Icons.app_registration,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// NAVIGATION TO SIGNIN
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Appconstant.appmaincolor),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => SignIn()),
                      child: Text(
                        " Signin",
                        style: TextStyle(
                          color:
                          Appconstant.appmaincolor,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Reusable TextField Widget (Cleaner Structure)
  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          cursorColor: Colors.red,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            contentPadding:
            const EdgeInsets.only(top: 2, left: 8),
            hintStyle:
            const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}