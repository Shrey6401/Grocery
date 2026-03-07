import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/models/product-model.dart';
import 'package:grocery/screens/userpanel/product%20detail.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true) // Sirf sale products dikhayega
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error"));

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No products found!"));
        }

        return SizedBox(
          height: Get.height / 4.5,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              // Safe Data Mapping
              final Map<String, dynamic> data =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;
              ProductModel productModel = ProductModel.fromMap(data);

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(()=>ProductDetail(productModel: productModel));
                  },
                  child: FillImageCard(
                    borderRadius: 20.0,
                    width: Get.width / 3.2,
                    heightImage: Get.height / 10,
                    // Check: Agar image array khali hai toh placeholder dikhao
                    imageProvider: (productModel.productImages.isNotEmpty)
                        ? CachedNetworkImageProvider(productModel.productImages[0])
                        : const NetworkImage("https://via.placeholder.com/150") as ImageProvider,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        productModel.productName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    footer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs ${productModel.salePrice}",
                          style: const TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "Rs ${productModel.fullPrice}",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Appconstant.appSecondaryColor,
                            decoration: TextDecoration.lineThrough, // Cross Price
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}