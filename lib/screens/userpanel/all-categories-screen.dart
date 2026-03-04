import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:grocery/models/categories-model.dart';
import 'package:grocery/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Appconstant.appTextColor,
        ),
        backgroundColor: Appconstant.appmaincolor,
        title: Text(
          "All Categories",
          style: TextStyle(color: Appconstant.appTextColor),
        ),
      ),
      body:  FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No category found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              height: Get.height / 5.0,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    categoryImg: snapshot.data!.docs[index]['categoryImg'],
                    categoryName: snapshot.data!.docs[index]['categoryName'],
                    createdAt: snapshot.data!.docs[index]['createdAt'],
                    updatedAt: snapshot.data!.docs[index]['updatedAt'],
                  );
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {},/*=> Get.to(() => AllSingleCategoryProductsScreen(
                          categoryId: categoriesModel.categoryId)
                      ),*/
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width / 4.0,
                              heightImage: Get.height / 12,
                              imageProvider: (categoriesModel.categoryImg != null && categoriesModel.categoryImg!.isNotEmpty)
                                  ? CachedNetworkImageProvider(categoriesModel.categoryImg!)
                                  : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                              title: Center(
                                child: Text(
                                  categoriesModel.categoryName,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return Container();
        },

      ),
    );
  }
}
