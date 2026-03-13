// ignore_for_file: file_names, avoid_print, unused_local_variable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery/models/order-model.dart';
import 'package:grocery/screens/userpanel/main-screen.dart';
import 'package:grocery/utils/app-constant.dart';

import 'genrate-order-id-service.dart';
//import 'notification_service.dart';
//import 'send_notification_service.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  //NotificationService notificationService = NotificationService();
  EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        // FIX: Added '??' to every field to prevent Null errors
        OrderModel cartModel = OrderModel(
          productId: data['productId'] ?? '',
          categoryId: data['categoryId'] ?? '',
          productName: data['productName'] ?? 'No Name',
          categoryName: data['categoryName'] ?? '',
          salePrice: data['salePrice'] ?? '0',
          fullPrice: data['fullPrice'] ?? '0',
          productImages: data['productImages'] ?? [],
          deliveryTime: data['deliveryTime'] ?? '',
          isSale: data['isSale'] ?? false,
          productDescription: data['productDescription'] ?? '',
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'] ?? DateTime.now(),
          productQuantity: data['productQuantity'] ?? 1,
          productTotalPrice: double.tryParse(data['productTotalPrice'].toString()) ?? 0.0,
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );

        // Upload Customer Info to main order doc
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .set(
          {
            'uId': user.uid,
            'customerName': customerName,
            'customerPhone': customerPhone,
            'customerAddress': customerAddress,
            'customerDeviceToken': customerDeviceToken,
            'orderStatus': false,
            'createdAt': DateTime.now()
          },
        );

        // Upload Specific Order item
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection('confirmOrders')
            .doc(orderId)
            .set(cartModel.toMap());

        // Delete from cart
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(user.uid)
            .collection('cartOrders')
            .doc(cartModel.productId.toString())
            .delete();

        // Save notification
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(user.uid)
            .collection('notifications')
            .add(
          {
            'title': "Order placed: ${cartModel.productName}",
            'body': cartModel.productDescription,
            'isSeen': false,
            'createdAt': DateTime.now(),
            'image': cartModel.productImages[0],
            'productId': cartModel.productId,
          },
        );
      }

      EasyLoading.dismiss();
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order!",
        backgroundColor: Appconstant.appmaincolor,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      Get.offAll(() => mainscreen());

    } catch (e) {
      EasyLoading.dismiss();
      print("Error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}