class ProductModel {
  ProductModel({
    required this.code,
    required this.name,
    required this.name1,
    required this.productId,
    //required this.qty,
  });

  final String code;
  final String name;
  final String name1;
  final String productId;
  //final int qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        name1: json["name1"] ?? "",
        productId: json["productId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "name1": name1,
        "productId": productId,
        
      };
}
