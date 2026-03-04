class ProductModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  ProductModel({
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
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      productName: json['productName'] ?? 'No Name',
      categoryName: json['categoryName'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      fullPrice: json['fullPrice'] ?? '0',
      productImages: json['productImages'] ?? [], // Crash proof
      deliveryTime: json['deliveryTime'] ?? '',
      isSale: json['isSale'] ?? false,
      productDescription: json['productDescription'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}