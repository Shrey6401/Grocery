import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/product-model.dart';
import 'package:grocery/screens/userpanel/product%20detail.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "All Products",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
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
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
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

              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetail(productModel: productModel));
                },
                child: FillImageCard(
                  borderRadius: 15,
                  width: Get.width / 2.3,
                  heightImage: 140,
                  imageProvider: productModel.productImages.isNotEmpty
                      ? CachedNetworkImageProvider(
                          productModel.productImages[0],
                        )
                      : const AssetImage('assets/images/placeholder.png')
                            as ImageProvider,

                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productModel.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "₹ ${productModel.fullPrice}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
