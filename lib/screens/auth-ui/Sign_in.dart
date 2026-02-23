import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/signin_controller.dart';
import 'package:grocery/screens/auth-ui/Sign_up.dart';
import 'package:grocery/screens/auth-ui/forget-password-screen.dart';
import 'package:grocery/screens/userpanel/main-screen.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final SignInController signInController = Get.put(SignInController());

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void dispose() {
    userEmail.dispose();
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
              "Sign in",
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
                    ? const SizedBox.shrink()
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

                /// PASSWORD FIELD
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                          () => TextFormField(
                        controller: userPassword,
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText:
                        !signInController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signInController.isPasswordVisible.toggle();
                            },
                            child: signInController.isPasswordVisible.value
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

                /// FORGOT PASSWORD
                Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (){
                      Get.to(()=>ForgetPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Appconstant.appmaincolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// SIGN IN BUTTON
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        String email =
                        userEmail.text.trim();
                        String password =
                        userPassword.text.trim();

                        if (email.isEmpty ||
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

                        UserCredential?
                        userCredential =
                        await signInController
                            .signInMethod(
                            email, password);

                        if (userCredential != null) {
                          if (userCredential
                              .user!
                              .emailVerified) {
                            Get.snackbar(
                              "Success",
                              "Login Successfully!",
                              snackPosition:
                              SnackPosition.BOTTOM,
                              backgroundColor:
                              Appconstant
                                  .appSecondaryColor,
                              colorText:
                              Appconstant
                                  .appTextColor,
                            );

                            // Navigate to Main Screen
                            // Replace with your actual screen
                             Get.offAll(() => mainscreen());

                          } else {
                            Get.snackbar(
                              "Error",
                              "Please verify your email before login",
                              snackPosition:
                              SnackPosition.BOTTOM,
                              backgroundColor:
                              Appconstant
                                  .appSecondaryColor,
                              colorText:
                              Appconstant
                                  .appTextColor,
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please try again",
                            snackPosition:
                            SnackPosition.BOTTOM,
                            backgroundColor:
                            Appconstant
                                .appSecondaryColor,
                            colorText:
                            Appconstant
                                .appTextColor,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Sign in",
                        style:
                        TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// NAVIGATION TO SIGN UP
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color:
                          Appconstant.appmaincolor),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => SignUp()),
                      child: Text(
                        " SignUp",
                        style: TextStyle(
                          color: Appconstant
                              .appmaincolor,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
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