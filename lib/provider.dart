
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier{
  List<Map<String,dynamic>> cart = [];

  void reassignCart(){
     print("Cart before clear: $cart"); // Print cart content before clearing
  cart.clear();
  print("Cart after clear: $cart"); // Print cart content after clearing
  notifyListeners();
  }

  void addToCart(Map<String,dynamic> product){

    int index = cart.indexWhere((ind)=> ind['productName']==product['productName'] && ind['sellerId']==product['sellerId']);
    
    print(index);
    if(index != -1){
      cart[index]['quantity'] += 1; 
      notifyListeners();
    }
    else{
      cart.add(product);
    notifyListeners();
    }
    
  }

  void subtractQuantity(Map<String,dynamic> product){
    int index = cart.indexWhere((ind)=> ind['productName']==product['productName'] && ind['sellerId']==product['sellerId']);
    if(cart[index]['quantity']==1)cart.remove(cart[index]);
    else{
      cart[index]['quantity'] -= 1;
    }
    notifyListeners();
  }

  void removeFromCart(Map<String,dynamic> product){
    cart.remove(product);
    notifyListeners();
  }

  double totalOrderValue(){
    double a = 0;
    cart.forEach((pro){
      a += double.parse(pro['productPrice'])*pro['quantity'];
    });
    return a;
  }

  

}