import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? categoryName;
  String? categoryLogo;
  String? backgroundColor;

  CategoryModel({this.categoryName, this.categoryLogo, this.backgroundColor});

  // receiving data from server
  factory CategoryModel.fromMap(map) {
    return CategoryModel(categoryName: map['categoryName'], categoryLogo: map['categoryLogo'], backgroundColor: map['backgroundColor']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'categories': FieldValue.arrayUnion([
        {
          'categoryName': categoryName,
          'categoryLogo': categoryLogo,
          'backgroundColor': backgroundColor,
        }
      ])
    };
  }
}
