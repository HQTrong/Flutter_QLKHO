import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxBool isLoadingUpdate = false.obs;
  RxBool isLoadingDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editProduct(Map<String, dynamic> data) async {
    try {
      await firestore.collection("products").doc(data["id"]).update({
        "name": data["name"],
        "name1": data["name1"],
      });

      return {
        "error": false,
        "message": "Cập nhật thành công sản phẩm.",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Không thể cập nhật sản phẩm.",
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      await firestore.collection("products").doc(id).delete();
      return {
        "error": false,
        "message": "Đã xóa thành công sản phẩm",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Không thể xóa sản phẩm",
      };
    }
  }
}
