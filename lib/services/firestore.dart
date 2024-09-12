import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  
  final CollectionReference vendor = FirebaseFirestore.instance.collection('vendors');
  final CollectionReference customer = FirebaseFirestore.instance.collection('customers');
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future<DocumentReference> addProducts(String productName, String productPrice,String imageUrl,String? vendorEmail){
    return  products.add({
      'productName': productName,
      'productPrice': productPrice,
      'imageUrl': imageUrl,
      'vendorEmail': vendorEmail
    }) ;
  }

  // Stream<QuerySnapshot> getProducts() {
  //       final users = FirebaseFirestore.instance.collection('products');
  //       return users.snapshots();
  // }

  Stream<QuerySnapshot> getUsers() {
        final users = FirebaseFirestore.instance.collection('users');
        return users.snapshots();
  }

  Stream<DocumentSnapshot> getCurrentUser(String email){
    final users =   FirebaseFirestore.instance.collection('users').doc(email);
    return users.snapshots() ;
  }

  Future<DocumentSnapshot> getCurrentVendor(String? email)async{
    return await FirebaseFirestore.instance.collection('vendors').doc(email!).get();
  }

   Stream<DocumentSnapshot> getVendor(String? email){
          final vendors = FirebaseFirestore.instance.collection('vendors').doc(email);
          return vendors.snapshots();
   }

    Stream<QuerySnapshot> getEntireVendor(){
          final vendors = FirebaseFirestore.instance.collection('vendors');
          return vendors.snapshots();
   }

   Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentProductQty(String user)async{
        return await FirebaseFirestore.instance.collection('user').doc(user).get();
   }

   void addCartDetailsToUser(String userEmail,String name,String price,String imageUrl,String sellerId){
    FirebaseFirestore.instance.collection("users").doc(userEmail).update({
      'cart': FieldValue.arrayUnion([{
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'sellerId':sellerId,
        'quantity':0
      }])
    });
   }

    void removeCartDetailsToUser(Map<String,dynamic> cartpro,String user){
    FirebaseFirestore.instance.collection("users").doc(user).update({
      'cart': FieldValue.arrayRemove([cartpro])
    });
   }
  
  void updateVendorsProduct(List? vendorsProducts,String? email){
    FirebaseFirestore.instance.collection('vendors').doc(email).update({'products':vendorsProducts});
  }

  // void addOrdersToUserAndVendor(List<Map<String,dynamic>> order,String user){
  //   final DateTime now = DateTime.now();
  //   int randomNumber = Random().nextInt(100000);
  //   FirebaseFirestore.instance.collection('users').doc(user).update({
  //     'orders':FieldValue.arrayUnion([{
  //       'orderId': now.millisecondsSinceEpoch.toString()+randomNumber.toString(),
  //       'orderDetails':order,
  //       'dateTime':now
  //     }])
  //   });

  //   Map<String,List<Map<String,dynamic>>> sellerWiseOrderPackage = {};

  //   order.forEach((pro){
  //     if(sellerWiseOrderPackage.containsKey(pro['sellerId'])){
  //       sellerWiseOrderPackage[pro['sellerId']]!.add(pro);
        
  //     }
  //     else{
  //       sellerWiseOrderPackage[pro['sellerId']] =[pro];  // Make sure this is a single level array of orders
        
  //     };
  //     }
  //   );

  //   sellerWiseOrderPackage.forEach((sellerId, orderData) {
  //     print(sellerId);
  //     print(orderData);
  //   FirebaseFirestore.instance.collection('vendors').doc(sellerId).update({
  //     'orders':FieldValue.arrayUnion([{
  //       'orderId':  now.millisecondsSinceEpoch.toString()+randomNumber.toString(),
  //       'ordersDetails': FieldValue.arrayUnion([orderData]),
  //       'dateTime': now
  //     }])
  //   });
  // });
  //   }

  void addOrdersToUserAndVendor(List<Map<String, dynamic>> order, String user,double totalOrderValue) {
  final DateTime now = DateTime.now();
  int randomNumber = Random().nextInt(100000);

  

  Map<String, List<Map<String, dynamic>>> sellerWiseOrderPackage = {};

  order.forEach((pro) {
    if (sellerWiseOrderPackage.containsKey(pro['sellerId'])) {
      sellerWiseOrderPackage[pro['sellerId']]!.add(pro);
    } else {
      sellerWiseOrderPackage[pro['sellerId']] = [pro];  // Ensure a single level array of orders
    }
  });

  // Update orders in the user's document
  FirebaseFirestore.instance.collection('users').doc(user).update({
    'orders': FieldValue.arrayUnion([{
      'orderId': now.millisecondsSinceEpoch.toString() + randomNumber.toString(),
      'orderDetails': sellerWiseOrderPackage,
      'dateTime': now,
      'totalOrderValue':totalOrderValue,
      'overallOrderStatus':'pending'
    }])
  });

  sellerWiseOrderPackage.forEach((sellerId, orderData) {
    print(sellerId);
    print(orderData);
    FirebaseFirestore.instance.collection('vendors').doc(sellerId).update({
      'orders': FieldValue.arrayUnion([{
        'orderId': now.millisecondsSinceEpoch.toString() + randomNumber.toString(),
        'ordersDetails': orderData,  // Directly add the list without arrayUnion
        'dateTime': now,
        'totalOrderValue':totalOrderValue,
        'buyerId':user,
        'overallOrderStatus':'pending'
      }])
    });
  });
}



  }

  
