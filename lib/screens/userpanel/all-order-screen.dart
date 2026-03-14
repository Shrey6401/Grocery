import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/utils/app-constant.dart';

// Note: Ensure you have an OrderModel or adjust your CartModel to include the 'status' field
import 'package:grocery/models/cart-model.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Appconstant.appmaincolor,
        title: const Text("All Orders", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // CHANGE: Target the 'orders' collection instead of 'cart'
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error fetching orders!"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productDoc = snapshot.data!.docs[index];
              Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

              // Using your model (ensure it matches the keys in your 'orders' collection)
              CartModel cartModel = CartModel.fromMap(data);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Appconstant.appmaincolor,
                    backgroundImage: CachedNetworkImageProvider(
                      cartModel.productImages.isNotEmpty ? cartModel.productImages[0] : '',
                    ),
                  ),
                  title: Text(cartModel.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Text("₹ ${cartModel.productTotalPrice.toStringAsFixed(1)}"),
                      const SizedBox(width: 10),

                      // VIDEO LOGIC: Show Status (Pending/Delivered)
                      // Assuming your order document has a 'status' boolean field
                      data['status'] == false
                          ? const Text(
                          "Pending",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                      )
                          : const Text(
                          "Delivered",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  // Removed the Plus/Minus buttons as orders are already confirmed
                  trailing: Text("Qty: ${cartModel.productQuantity}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}