import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Huỳnh Quốc Trọng"),
        centerTitle: true,
        
      ),
    
      body:
       GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) 
        {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) 
          {
            case 0:
              title = "Thêm Sản Phẩm";
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                // Get data dari firebase search by product id
                Map<String, dynamic> product = {
                    "code": barcode,
                    "name": "SP ${barcode.substring(0,5)}",
                    "productId": "",
                    "name1": "1",
                  };
                    Map<String, dynamic> hasil =
                    await controller.addProduct(product);
                if (hasil["Success"] == false) {
                  Get.snackbar(
                    "Success",
                    hasil["message"],
                    duration: const Duration(seconds: 2),   
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    hasil["message"],
                    duration: const Duration(seconds: 2),
                  );
                }
                  
                
              };
              break;
            case 1:
              title = "Tồn Kho";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.products);
              break;
            case 2:
              title = "Lấy Sản Phẩm";
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                // Get data dari firebase search by product id
                Map<String, dynamic> hasil =
                    await controller.getProductById(barcode);
                if (hasil["error"] == false) {
                  Get.toNamed(Routes.detailProduct, arguments: hasil["data"]);
                } else {
                  Get.snackbar(
                    "Error",
                    hasil["message"],
                    duration: const Duration(seconds: 2),
                  );
                }
              };
              break;
            case 3:
              title = "Logout";
              return FloatingActionButton(
                onPressed: () async {
                  Map<String, dynamic> hasil = await authC.logout();
                  if (hasil["error"] == false) {
                    Get.offAllNamed(Routes.login);
                  } else {
                    Get.snackbar("Error", hasil["error"]);
                  }
                },
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 50, color: Colors.black),
                    Text(title, style: TextStyle(color: Colors.black)),
                  ],
                ),
              );
             break;
          }
          return Material
          (
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell
            (
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(icon, size: 50),
                  ),
                  const SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        }
       )
       );

   }
  
  }
  

