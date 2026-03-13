import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controllers/cart-price-controller.dart';
import 'package:grocery/models/cart-model.dart';
import 'package:grocery/screens/userpanel/checkout%20screen.dart';
import 'package:grocery/utils/app-constant.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(ProductPriceController());

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
          if (snapshot.hasError) return const Center(child: Text("Error!"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            // Ensure the grand total at the bottom resets to 0
            WidgetsBinding.instance.addPostFrameCallback((_) {
              productPriceController.totalPrice.value = 0.0;
            });
            return const Center(child: Text("Cart is empty!"));
          }

          // Trigger total calculation whenever data changes
          productPriceController.fetchProductPrice();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final productDoc = snapshot.data!.docs[index];
                    Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

                    // Mapping to our model
                    CartModel cartModel = CartModel.fromMap(data);

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            cartModel.productImages.isNotEmpty ? cartModel.productImages[0] : '',
                          ),
                        ),
                        title: Text(cartModel.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            Text(
                              "₹ ${cartModel.productTotalPrice.toStringAsFixed(1)}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(width: 15),

                            /// MINUS BUTTON
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 1) {
                                  int newQty = cartModel.productQuantity - 1;

                                  // Get unit price from model (handles String-to-Double parsing)
                                  double unitPrice = cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice;

                                  if (unitPrice > 0) {
                                    await FirebaseFirestore.instance
                                        .collection('cart').doc(user!.uid)
                                        .collection('cartOrders').doc(cartModel.productId)
                                        .update({
                                      'productQuantity': newQty,
                                      'productTotalPrice': (unitPrice * newQty),
                                    });
                                  }
                                }
                              },
                              child: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${cartModel.productQuantity}"),
                            ),

                            /// PLUS BUTTON
                            GestureDetector(
                              onTap: () async {
                                int newQty = cartModel.productQuantity + 1;
                                double unitPrice = cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice;

                                // CHECK: Only update if the base price was found
                                if (unitPrice > 0) {
                                  await FirebaseFirestore.instance
                                      .collection('cart').doc(user!.uid)
                                      .collection('cartOrders').doc(cartModel.productId)
                                      .update({
                                    'productQuantity': newQty,
                                    'productTotalPrice': (unitPrice * newQty),
                                  });
                                } else {
                                  Get.snackbar(
                                    "Data Error",
                                    "Base price missing in this Cart record. Please delete and re-add this item.",
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              child: const Icon(Icons.add_circle_outline, color: Colors.green),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('cart').doc(user!.uid)
                                .collection('cartOrders').doc(cartModel.productId)
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // DYNAMIC BOTTOM NAVIGATION TOTAL
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                        "Total: ₹ ${productPriceController.totalPrice.value.toStringAsFixed(1)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Appconstant.appmaincolor),
                        onPressed: () {
                          Get.to(()=> CheckOutScreen());
                        },
                        child: const Text("Checkout", style: TextStyle(color: Colors.white))
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}