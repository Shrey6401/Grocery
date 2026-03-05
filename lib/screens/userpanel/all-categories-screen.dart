import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/categories-model.dart';
import 'package:grocery/screens/userpanel/single-category-product-screen.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        iconTheme: IconThemeData(color: Appconstant.appTextColor),
        title: Text(
          "All Categories",
          style: TextStyle(color: Appconstant.appTextColor),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .snapshots(),

        builder: (context, snapshot) {

          /// ERROR STATE
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          /// LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          /// EMPTY STATE
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No categories found"),
            );
          }

          /// DATA FOUND
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),

            itemBuilder: (context, index) {

              final data = snapshot.data!.docs[index];

              CategoriesModel categoriesModel = CategoriesModel(
                categoryId: data['categoryId'],
                categoryImg: data['categoryImg'],
                categoryName: data['categoryName'],
                createdAt: data['createdAt'],
                updatedAt: data['updatedAt'],
              );

              return GestureDetector(
                onTap: () {

                  /// Navigate to products of that category
                  Get.to(() => AllSingleCategoryProductsScreen(
                        categoryId: categoriesModel.categoryId,
                      ));

                },

                child: FillImageCard(
                  borderRadius: 20,
                  width: Get.width,
                  heightImage: Get.height / 8,

                  imageProvider:
                  (categoriesModel.categoryImg != null &&
                      categoriesModel.categoryImg!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                      categoriesModel.categoryImg!)
                      : const AssetImage(
                      'assets/images/placeholder.png')
                  as ImageProvider,

                  title: Center(
                    child: Text(
                      categoriesModel.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}