import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rishis_locale_connect/provider.dart';
import 'package:rishis_locale_connect/services/firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {

 void logout(){
      
      FirebaseAuth.instance.signOut();

    }
  
  List<Widget> shopAndProductScreens = [ShopsPageInCustomerPage(),ProductsPageInCustomerHomePage()];
      int toggleScreenIndex = 0;

  @override
  Widget build(BuildContext context) {

      

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home")),
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
          SizedBox(height: 10),
          ToggleSwitch(
            initialLabelIndex: toggleScreenIndex,
            totalSwitches: 2 ,
            labels: ['Shops','Products'],
            onToggle: (index) {
              setState(() {
                toggleScreenIndex = index!;
              });
            },

          ),
          Expanded(child: shopAndProductScreens[toggleScreenIndex]),
        ],
      )

    );
  }
}

class ProductsPageInCustomerHomePage extends StatefulWidget {
  const ProductsPageInCustomerHomePage({super.key});

  @override
  State<ProductsPageInCustomerHomePage> createState() => _ProductsPageInCustomerHomePageState();
}

class _ProductsPageInCustomerHomePageState extends State<ProductsPageInCustomerHomePage> {
  
  
  
   FirestoreService firestoreServices = FirestoreService();
   String currentUser = FirebaseAuth.instance.currentUser!.email!;
   List<Map<String,String>> cartProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          StreamBuilder(
            stream: firestoreServices.getEntireVendor() , 
            builder: (context,snapshot){
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching products'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No products found'));
              }
          
              List<QueryDocumentSnapshot> vendorCollectionQueryDocumentSnapshot = snapshot.data!.docs;
              List productList = [];
          
              for(int i=0;i<vendorCollectionQueryDocumentSnapshot.length;i++){
                    var a = vendorCollectionQueryDocumentSnapshot[i].get('products');
                    a.forEach((pro){
                      pro['sellerId']= vendorCollectionQueryDocumentSnapshot[i].id;
                        productList.add(pro);
                    });
                   
              }

print("Hi");
print("hello");//for git
              
              
          
              return SizedBox(
                height: 500,
                child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1
                
                  ), 
                  itemCount: productList.length,
                  itemBuilder: (context,Index){
                    return Card(
                      
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(productList[Index]['imageUrl']),
                          ),
                          Text(productList[Index]['productName']),
                          Text(productList[Index]['productPrice']),
                          IconButton(onPressed: (){

                              Provider.of<CartProvider>(context,listen : false).addToCart({
                                'imageUrl': productList[Index]['imageUrl'],
                                'productName': productList[Index]['productName'],
                                'productPrice': productList[Index]['productPrice'],
                                'sellerId': productList[Index]['sellerId'],
                                'quantity': 1,
                                'orderStatus':'pending'
                              });

                            // firestoreServices.addCartDetailsToUser(currentUser, productList[Index]['productName'], productList[Index]['productPrice'], productList[Index]['imageUrl'], productList[Index]['sellerId']);
                          }, icon: Icon(Icons.add))
                        ],
                      ),
                    );
                  }),
              );
            }),
        ],
      ),

      
    );
  }
}

class ShopsPageInCustomerPage extends StatefulWidget {
  const ShopsPageInCustomerPage({super.key});

  @override
  State<ShopsPageInCustomerPage> createState() => _ShopsPageInCustomerPageState();
}

class _ShopsPageInCustomerPageState extends State<ShopsPageInCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}