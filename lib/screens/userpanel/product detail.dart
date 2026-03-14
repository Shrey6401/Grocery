import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/product-model.dart';
import 'package:grocery/screens/userpanel/cart%20screen.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetail({super.key, required this.productModel});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Appconstant.appTextColor),
        backgroundColor: Appconstant.appmaincolor,
        title: Text(
          "Product Details",
          style: TextStyle(color: Appconstant.appTextColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(CartScreen());
            },
            icon: Icon(CupertinoIcons.cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height / 60),

            // Image Carousel
            CarouselSlider(
              items: widget.productModel.productImages.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: Get.width,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                viewportFraction: 1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name & Favorite
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.productModel.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Icon(Icons.favorite_outline, color: Colors.red),
                        ],
                      ),
                    ),

                    // Price Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.productModel.isSale &&
                            widget.productModel.salePrice.isNotEmpty
                            ? "Rs: ${widget.productModel.salePrice}"
                            : "Rs: ${widget.productModel.fullPrice}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Appconstant.appSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Category & Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Category: ${widget.productModel.categoryName}",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.productModel.productDescription),
                    ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              sendwhatsapp(productModel: widget.productModel);
                            },
                            child: _buildActionButton("WhatsApp", Colors.green),
                          ),
                          GestureDetector(
                            onTap: () async {
                              User? currentUser =
                                  FirebaseAuth.instance.currentUser;

                              if (currentUser != null) {
                                await checkProductExistence(
                                  uId: currentUser.uid,
                                );
                              } else {
                                Get.snackbar(
                                  "Login Required",
                                  "Please login to add items to cart",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            child: _buildActionButton(
                              "Add to cart",
                              Appconstant.appSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for buttons
  Widget _buildActionButton(String label, Color color) {
    return Container(
      width: Get.width / 2.4,
      height: Get.height / 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Appconstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // WhatsApp Logic from video reference
  static Future<void> sendwhatsapp({required ProductModel productModel}) async {
    // International format WITHOUT '+' or spaces
    const String number = "917827539557";

    final String message = "Hi Shrey Sharma,\n\n"
        "I want to know about this Product:\n"
        "Product Name: ${productModel.productName}\n"
        "Product Price: ${productModel.isSale ? productModel.salePrice : productModel.fullPrice}";

    final Uri url = Uri.parse(
        "https://wa.me/$number?text=${Uri.encodeComponent(message)}"
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          "Error",
          "WhatsApp is not installed on this device",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("WhatsApp error: $e");
    }
  }

  // logic for Adding/Updating Cart
  Future<void> checkProductExistence({required String uId}) async {
    try {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('cart')
          .doc(uId)
          .collection('cartOrders')
          .doc(widget.productModel.productId.toString());

      DocumentSnapshot snapshot = await documentReference.get();

      if (snapshot.exists) {
        int currentQuantity = snapshot['productQuantity'];
        int updatedQuantity = currentQuantity + 1;

        double price = double.parse(
          widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice,
        );

        await documentReference.update({
          'productQuantity': updatedQuantity,
          'productTotalPrice': price * updatedQuantity,
        });

        Get.snackbar(
          "Cart Updated",
          "Increased quantity of this item",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        await FirebaseFirestore.instance.collection('cart').doc(uId).set({
          'uId': uId,
          'lastUpdated': DateTime.now(),
        }, SetOptions(merge: true));

        double price = double.parse(
          widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice,
        );

        await documentReference.set({
          'productId': widget.productModel.productId,
          'productName': widget.productModel.productName,
          'categoryName': widget.productModel.categoryName,
          'productDescription': widget.productModel.productDescription,
          'productImages': widget.productModel.productImages,
          'deliveryTime': widget.productModel.deliveryTime,
          'isSale': widget.productModel.isSale,
          'productQuantity': 1,
          'productTotalPrice': price,
          'createdAt': DateTime.now(),
        });

        Get.snackbar(
          "Success",
          "Added to cart",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }
}