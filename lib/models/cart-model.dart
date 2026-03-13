// ignore_for_file: file_names

class CartModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;

  final double salePrice;
  final double fullPrice;

  final List<String> productImages;
  final String deliveryTime;

  final bool isSale;
  final String productDescription;

  final dynamic createdAt;
  final dynamic updatedAt;

  final int productQuantity;
  final double productTotalPrice;

  CartModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      productName: json['productName'] ?? '',
      categoryName: json['categoryName'] ?? '',

      salePrice: _parsePrice(json['salePrice']),
      fullPrice: _parsePrice(json['fullPrice']),

      productImages: List<String>.from(json['productImages'] ?? []),
      deliveryTime: json['deliveryTime'] ?? '',

      isSale: json['isSale'] ?? false,
      productDescription: json['productDescription'] ?? '',

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      productQuantity: (json['productQuantity'] ?? 1) as int,
      productTotalPrice: _parsePrice(json['productTotalPrice']),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }
}