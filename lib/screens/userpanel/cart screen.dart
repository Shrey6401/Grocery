import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/cart-model.dart';
import 'package:grocery/utils/app-constant.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: const Text("My Cart", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Kuch galat hua!"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Cart khali hai!"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              String docString = productData.data().toString();

              // Sabhi fields ke liye Safe Mapping
              CartModel cartModel = CartModel(
                productId: docString.contains('productId') ? productData['productId'] : '',
                categoryId: docString.contains('categoryId') ? productData['categoryId'] : '',
                productName: docString.contains('productName') ? productData['productName'] : 'Unknown',
                categoryName: docString.contains('categoryName') ? productData['categoryName'] : '',
                salePrice: docString.contains('salePrice') ? productData['salePrice'] : '',
                fullPrice: docString.contains('fullPrice') ? productData['fullPrice'] : '',
                productImages: docString.contains('productImages')
                    ? List<String>.from(productData['productImages'])
                    : [],
                deliveryTime: docString.contains('deliveryTime') ? productData['deliveryTime'] : '',
                isSale: docString.contains('isSale') ? productData['isSale'] : false,
                productDescription: docString.contains('productDescription') ? productData['productDescription'] : '',
                createdAt: docString.contains('createdAt') ? productData['createdAt'] : null,
                updatedAt: docString.contains('updatedAt') ? productData['updatedAt'] : null,
                productQuantity: docString.contains('productQuantity') ? productData['productQuantity'] : 1,
                productTotalPrice: docString.contains('productTotalPrice')
                    ? double.parse(productData['productTotalPrice'].toString())
                    : 0.0,
              );

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      cartModel.productImages.isNotEmpty ? cartModel.productImages[0] : 'https://via.placeholder.com/150',
                    ),
                  ),
                  title: Text(cartModel.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Text("₹ ${cartModel.productTotalPrice}"),
                      const SizedBox(width: 15),
                      // Quantity Buttons (Design purposes)
                      const Icon(Icons.remove_circle_outline, size: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("${cartModel.productQuantity}"),
                      ),
                      const Icon(Icons.add_circle_outline, size: 18),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('cart')
                          .doc(user!.uid)
                          .collection('cartOrders')
                          .doc(cartModel.productId)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      // YE RAHA AAPKA CHECKOUT SECTION!
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total: ₹ XXXX", // Isse hum agle video/lecture mein dynamic karenge
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: Appconstant.appmaincolor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Checkout logic yahan aayega
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}