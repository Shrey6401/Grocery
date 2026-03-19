import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/order-model.dart';
import 'package:grocery/screens/userpanel/add-review-screen.dart';
import 'package:grocery/utils/app-constant.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Appconstant.appmaincolor,
        title: const Text("All Orders", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Streaming from the 'orders' -> 'uid' -> 'confirmOrders' collection
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .orderBy('createdAt', descending: true) // Added ordering for better UX
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching orders!"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productDoc = snapshot.data!.docs[index];
              Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

              // Map the data to your OrderModel
              OrderModel orderModel = OrderModel.fromMap(data);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: orderModel.productImages.isNotEmpty
                          ? orderModel.productImages[0]
                          : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    orderModel.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("Total: ₹ ${orderModel.productTotalPrice.toStringAsFixed(1)}"),
                      const SizedBox(height: 5),

                      // Status Logic
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: orderModel.status ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          orderModel.status ? "Delivered" : "Pending",
                          style: TextStyle(
                            color: orderModel.status ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Only show Review button if status is TRUE (Delivered)
                  trailing: orderModel.status
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appconstant.appmaincolor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Get.to(AddReviewScreen(orderModel: orderModel));
                    },
                    child: const Text("Review"),
                  )
                      : SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}