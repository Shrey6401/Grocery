// ignore_for_file: file_names

class CategoriesModel {
  final String categoryId;
  final String? categoryImg; // 1. Added '?' to make this nullable
  final String categoryName;
  final dynamic createdAt;
  final dynamic updatedAt;

  CategoriesModel({
    required this.categoryId,
    this.categoryImg, // 2. Removed 'required' for the image
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryImg': categoryImg,
      'categoryName': categoryName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      // 3. Added null-checks (??) to prevent "Bad State" errors
      categoryId: json['categoryId'] ?? '',
      categoryImg: json['categoryImg'] ?? '', // Fallback to empty string if missing
      categoryName: json['categoryName'] ?? 'No Name',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}