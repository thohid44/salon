import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyShopping/controllers/auth_controller.dart';
import 'package:happyShopping/utils/colors.dart';
import 'package:happyShopping/views/auth/login/login.dart';
import 'package:happyShopping/views/cart/cart.dart';
import 'package:happyShopping/widgets/custom_app_bar.dart';
import 'package:happyShopping/widgets/custom_single_product_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                var authController = Get.put(AuthController());
                authController.user.value = ''; 
                Get.offAll(LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {},
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                value: '1',
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello Flora 👋',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                'Let’s start shopping!',
                style: TextStyle(
                  color: Colors.black.withOpacity(.5),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('banners')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return CarouselSlider.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                                snapshot.data!.docs[itemIndex].data()['data']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        height: 140,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (_, index) {
                          final data = snapshot.data!.docs[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.catBackground,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black.withOpacity(.1),
                                width: 2,
                              ),
                            ),
                            child: Image.network(data['icon']),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: .9,
                      ),
                      itemBuilder: (context, index) {
                        return CustomSingleProductGrid(
                          product: snapshot.data!.docs[index],
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
