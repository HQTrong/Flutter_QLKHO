import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();

    var getData = await firestore.collection("products").get();

    // reset all products -> untuk mengatasi duplikat
    allProducts([]);

    // isi data allProducts dari database
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    // memasukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }
 Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
  try {
          var hasil = await firestore
          .collection("products")
          .where("code", isEqualTo: product["code"])
          .get();
          
  if (hasil.docs.isNotEmpty) {
    var docId = hasil.docs[0].id;
    int sl = int.parse(hasil.docs[0].data()["name1"]) + 1;
    String name1 = sl.toString();
    await firestore.collection("products").doc(docId).update({
      "name1": name1,
    });
    return {
      "error": true,
      "message": "Sản phẩm này đã tồn tại trong kho.\nSố lượng sản phẩm đã được tăng thêm 1",
    };
  }
        else
        {
            var hasil = await firestore.collection("products").add(product);
  await firestore.collection("products").doc(hasil.id).update({
        "productId": hasil.id,
      });
      return {
        "Success": false,
        "message": "Đã thêm sản phẩm thành công",
      };
        }
    
  } catch (e) {
    // Error general
    //print(e);
    return {
      "error": true,
      "message": "Không thể thêm sản phẩm.",
    };
  }
}

  Future<Map<String, dynamic>> getProductById(String codeBarang) async {
    try {
      var hasil = await firestore
          .collection("products")
          .where("code", isEqualTo: codeBarang)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Sản phẩm này không tồn tại trong kho.",
        };
      }
        if (hasil.docs.isNotEmpty) {
    var docId = hasil.docs[0].id;
    int sl = int.parse(hasil.docs[0].data()["name1"]) - 1;
    String name1 = sl.toString();
    await firestore.collection("products").doc(docId).update({
      "name1": name1,
    });
    if(sl==0)
    {
      await firestore.collection("products").doc(codeBarang).delete();
    }
    return {
      "error": true,
      "message": "Lấy sản phẩm thành công",
    };
    
  }
 

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Được quản lý để lấy chi tiết sản phẩm từ mã sản phẩm này.",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Không nhận được chi tiết sản phẩm từ mã sản phẩm này.",
      };
    }
  }
}
