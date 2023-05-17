import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/products_controller.dart';
import 'package:intl/intl.dart';

class ProductsView extends GetView<ProductsController> {
  
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SẢN PHẨM TRONG KHO'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapProducts) {
          if (snapProducts.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapProducts.data!.docs.isEmpty) {
            return const Center(
              child: Text("Không có sản phẩm nào"),
            );
          }

          List<ProductModel> allProducts = [];

          for (var element in snapProducts.data!.docs) {
            allProducts.add(ProductModel.fromJson(element.data()));
          }

          return ListView.builder(
            itemCount: allProducts.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              ProductModel product = allProducts[index];
return Card(
  elevation: 6,
  margin: const EdgeInsets.only(bottom: 20),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(9),
  ),
  child: InkWell(
    onTap: () {
      Get.toNamed(Routes.detailProduct, arguments: product);
    },
    borderRadius: BorderRadius.circular(9),
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Sản phẩm : ${product.name}"),
                Text("Số lượng : ${product.name1}"+"\n"+"Ngày nhập: $formattedDate"),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: QrImage(
              data: product.code,
              size: 200.0,
              version: QrVersions.auto,
            ),
          ),
        ],
      ),
    ),
  ),
);
            },
          );
        },
      ),
    );
  }
}
