import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/product-model.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class AllFlashSaleProductScreen extends StatefulWidget {
  const AllFlashSaleProductScreen({super.key});

  @override
  State<AllFlashSaleProductScreen> createState() =>
      _AllFlashSaleProductScreenState();
}

class _AllFlashSaleProductScreenState extends State<AllFlashSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        iconTheme: IconThemeData(color: Appconstant.appTextColor),
        title: Text(
          "Flash Sale",
          style: TextStyle(color: Appconstant.appTextColor),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }

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
              final productData = snapshot.data!.docs[index];

              ProductModel productModel = ProductModel(
                productId: productData['productId'] ?? '',
                categoryId: productData['categoryId'] ?? '',
                productName: productData['productName'] ?? '',
                categoryName:
                    productData.data().toString().contains('categoryName')
                    ? productData['categoryName']
                    : '',
                salePrice: productData['salePrice'] ?? '',
                fullPrice: productData['fullPrice'] ?? '',
                productImages: List<String>.from(
                  productData['productImages'] ?? [],
                ),
                deliveryTime: productData['deliveryTime'] ?? '',
                isSale: productData['isSale'] ?? false,
                productDescription:
                    productData.data().toString().contains('productDescription')
                    ? productData['productDescription']
                    : '',
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
              );
              return FillImageCard(
                borderRadius: 20,
                width: Get.width,
                heightImage: Get.height / 8,

                imageProvider: (productModel.productImages.isNotEmpty)
                    ? CachedNetworkImageProvider(productModel.productImages[0])
                    : const AssetImage('assets/images/placeholder.png')
                          as ImageProvider,

                title: Center(
                  child: Text(
                    productModel.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
