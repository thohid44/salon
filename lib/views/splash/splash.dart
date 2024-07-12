import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyShopping/controllers/auth_controller.dart';
import 'package:happyShopping/utils/colors.dart';
import 'package:happyShopping/utils/config.dart';
import 'package:happyShopping/views/home/home.dart';
import 'package:happyShopping/views/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    authController.user.value = user.toString(); 
    Timer(const Duration(seconds: 3), () {
   
        Get.offAll(() => const WelcomeScreen());
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        child: const Center(
          child: Text(
            AppConfig.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
