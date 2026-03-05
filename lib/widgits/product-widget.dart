import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/product-model.dart';
import 'package:image_card/image_card.dart';

class AllProductSaleScreen extends StatefulWidget {
  const AllProductSaleScreen({super.key});

  @override
  State<AllProductSaleScreen> createState() => _AllProductSaleScreenState();
}

class _AllProductSaleScreenState extends State<AllProductSaleScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Filtering products for your grocery app
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
          shrinkWrap: true, // Crucial for nested scrolling
          physics: const NeverScrollableScrollPhysics(), // Prevents scroll conflict
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            // Increased ratio to prevent vertical RenderFlex overflow
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final productData = snapshot.data!.docs[index];

            ProductModel productModel = ProductModel(
              productId: productData['productId'] ?? '',
              categoryId: productData['categoryId'] ?? '',
              productName: productData['productName'] ?? '',
              categoryName: productData.data().toString().contains('categoryName')
                  ? productData['categoryName']
                  : '',
              salePrice: productData['salePrice'] ?? '',
              fullPrice: productData['fullPrice'] ?? '',
              productImages: List<String>.from(productData['productImages'] ?? []),
              deliveryTime: productData['deliveryTime'] ?? '',
              isSale: productData['isSale'] ?? false,
              productDescription: productData.data().toString().contains('productDescription')
                  ? productData['productDescription']
                  : '',
              createdAt: productData['createdAt'],
              updatedAt: productData['updatedAt'],
            );

            return FillImageCard(
              borderRadius: 20,
              width: Get.width / 2.3,
              // Reduced image height to leave more room for text
              heightImage: 110,
              imageProvider: (productModel.productImages.isNotEmpty)
                  ? CachedNetworkImageProvider(productModel.productImages[0])
                  : const AssetImage('assets/images/placeholder.png') as ImageProvider,
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Prevents column from expanding
                  children: [
                    Text(
                      productModel.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹ ${productModel.fullPrice}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}