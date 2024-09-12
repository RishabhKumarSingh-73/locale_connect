import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rishis_locale_connect/provider.dart';
import 'package:rishis_locale_connect/services/firestore.dart';

class CustomerCartPage extends StatefulWidget {
  const CustomerCartPage({super.key});

  @override
  State<CustomerCartPage> createState() => _CustomerCartPageState();
}

class _CustomerCartPageState extends State<CustomerCartPage> {

   void logout(){
    FirebaseAuth.instance.signOut();
    }
  FirestoreService firestoreServices = FirestoreService();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
      List<Map<String,dynamic>> cartProducts = Provider.of<CartProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Cart")),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            Provider.of<CartProvider>(context,listen: false).reassignCart();
            logout();
          }, icon: Icon(Icons.logout))
        ],
      ),

      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context,Index){
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(cartProducts[Index]['imageUrl']),),
                      title: Text(cartProducts[Index]['productName']),
                      subtitle: Column(children: [
                        Text("price: ${cartProducts[Index]['productPrice']}"),
                        Text('Quantity: ${cartProducts[Index]['quantity']}'),
                      ],),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(children: [
                          IconButton(onPressed: (){
                            Provider.of<CartProvider>(context,listen: false).addToCart(cartProducts[Index]);
                          }, icon: Icon(Icons.add)),
                          IconButton(onPressed: (){
                            Provider.of<CartProvider>(context,listen: false).subtractQuantity(cartProducts[Index]);
                          }, icon: Icon(Icons.remove)),
                          IconButton(onPressed: (){
                          // firestoreServices.removeCartDetailsToUser({
                            // 'imageUrl': productList[Index]['imageUrl'],
                            // 'name': productList[Index]['name'],
                            // 'price': productList[Index]['price'],
                            // 'sellerId':productList[Index]['sellerId']
                          // }, currentUser);
                        
                          Provider.of<CartProvider>(context,listen: false).removeFromCart({
                            'imageUrl': cartProducts[Index]['imageUrl'],
                            'name': cartProducts[Index]['productName'],
                            'price': cartProducts[Index]['productPrice'],
                            'sellerId':cartProducts[Index]['sellerId'],
                            'quantity':cartProducts[Index]['quantity']
                          });
                        }, icon: Icon(Icons.delete)),
                        ],),
                      )
                    );
                  })
          ),
          

            Card(
              child: Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Total order value: ${Provider.of<CartProvider>(context,listen: false).totalOrderValue()}"),
                  Spacer(),
                  IconButton(onPressed: (){
                    
                    firestoreServices.addOrdersToUserAndVendor(cartProducts, currentUser,Provider.of<CartProvider>(context,listen: false).totalOrderValue());
                    Provider.of<CartProvider>(context,listen: false).reassignCart();
                  }, icon: Icon(Icons.check),)
                ],
              ),
            )
        ],
      )
    );
  }
}