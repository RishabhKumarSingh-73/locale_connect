import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFirestoreService{

  void individualProductAcceptance(String buyer,String seller,int outerIndex,int index)async{
    
    
    //seller update
    DocumentSnapshot<Map<String,dynamic>> wholeVendorSnapshot =  await FirebaseFirestore.instance.collection('vendors').doc(seller).get();
    Map<String,dynamic> wholeVendor = wholeVendorSnapshot.data()!;
    Map<String,dynamic> currentProduct = wholeVendor['orders'][outerIndex]['ordersDetails'][index];
    currentProduct['orderStatus'] = 'accepted';
    wholeVendor['orders'][outerIndex]['ordersDetails'][index] = currentProduct;
    FirebaseFirestore.instance.collection('vendors').doc(seller).update(wholeVendor);

    //user update
    DocumentSnapshot<Map<String,dynamic>> wholeUserSnapshot = await FirebaseFirestore.instance.collection('users').doc(buyer).get();
    Map<String,dynamic> wholeUser = wholeUserSnapshot.data()!;
    List orders = wholeUser['orders'] ;
    int userOuterIndex = -1;
    orders.forEach((order){
      userOuterIndex = userOuterIndex + 1;
      if(order['orderId']==wholeVendor['orders'][outerIndex]['orderId']){
        orders[userOuterIndex]['orderDetails'][seller][index]['orderStatus'] = 'accepted';
      }
    });
    FirebaseFirestore.instance.collection('users').doc(buyer).update({
      'orders':orders
    });

    
  }

  void individualProductRejectance(String buyer,String seller,int outerIndex,int index)async{
    
    
    //seller update
    DocumentSnapshot<Map<String,dynamic>> wholeVendorSnapshot =  await FirebaseFirestore.instance.collection('vendors').doc(seller).get();
    Map<String,dynamic> wholeVendor = wholeVendorSnapshot.data()!;
    Map<String,dynamic> currentProduct = wholeVendor['orders'][outerIndex]['ordersDetails'][index];
    currentProduct['orderStatus'] = 'rejected';
    wholeVendor['orders'][outerIndex]['ordersDetails'][index] = currentProduct;
    FirebaseFirestore.instance.collection('vendors').doc(seller).update(wholeVendor);

    //user update
    DocumentSnapshot<Map<String,dynamic>> wholeUserSnapshot = await FirebaseFirestore.instance.collection('users').doc(buyer).get();
    Map<String,dynamic> wholeUser = wholeUserSnapshot.data()!;
    List orders = wholeUser['orders'] ;
    int userOuterIndex = -1;
    orders.forEach((order){
      userOuterIndex = userOuterIndex + 1;
      if(order['orderId']==wholeVendor['orders'][outerIndex]['orderId']){
        orders[userOuterIndex]['orderDetails'][seller][index]['orderStatus'] = 'rejected';
      }
    });
    FirebaseFirestore.instance.collection('users').doc(buyer).update({
      'orders':orders
    });

    
  }
}