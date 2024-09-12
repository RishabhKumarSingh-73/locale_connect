import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rishis_locale_connect/provider.dart';
import 'package:rishis_locale_connect/services/firestore.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({super.key});

  @override
  State<CustomerOrderPage> createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {

  FirestoreService firestoreServices = FirestoreService();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;



  void logout(){
    FirebaseAuth.instance.signOut();
    }

  void retrieveSelectedOrder(int index){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Orders")),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            Provider.of<CartProvider>(context,listen: false).reassignCart();
            logout();
          }, icon: Icon(Icons.logout))
        ],
      ),

      body: StreamBuilder(
        stream: firestoreServices.getCurrentUser(currentUser), 
        builder: (context,snapshot){
           if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching products'));
              } 

           List<dynamic> userOverallOrders = snapshot.data!.get('orders') ;
            

           return ListView.builder(
            itemCount: userOverallOrders.length,
            itemBuilder: (context,Index){
              return GestureDetector(

                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=> VendorWithinUserOrderPackage(vendorWiseOrderList: userOverallOrders[Index]['orderDetails'],))),
                child: ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text(userOverallOrders[Index]['orderId']),
                  subtitle: Column(
                    children: [
                      Text("date&time: ${userOverallOrders[Index]['dateTime'].toString()}"),
                      Text("totalOrderValue: ${userOverallOrders[Index]['totalOrderValue']}")
                    ],
                  ),
                ),
              );
           });
        }),
    );
  }
}

class OrderWithinOrderPackagePage extends StatefulWidget {
  final List ordersOfSelectedVendor;
  const OrderWithinOrderPackagePage({super.key, required this.ordersOfSelectedVendor});

  @override
  State<OrderWithinOrderPackagePage> createState() => _OrderWithinOrderPackagePageState();
}

class _OrderWithinOrderPackagePageState extends State<OrderWithinOrderPackagePage> {

  FirestoreService firestoreServices = FirestoreService();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: Center(child: Text("Orders")),
        backgroundColor: Colors.blue,
       
      ),

      body: ListView.builder(
        itemCount: widget.ordersOfSelectedVendor.length,
        itemBuilder: (context,Index){
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.ordersOfSelectedVendor[Index]['imageUrl']),
            ),
            title: Text(widget.ordersOfSelectedVendor[Index]['productName']),
            subtitle: Column(children: [
                        Text("price: ${widget.ordersOfSelectedVendor[Index]['productPrice']}"),
                        Text('Quantity: ${widget.ordersOfSelectedVendor[Index]['quantity']}'),
                      ],),
          );
        })
    );
  }
}

class VendorWithinUserOrderPackage extends StatefulWidget {
  final Map<String,dynamic> vendorWiseOrderList;
  const VendorWithinUserOrderPackage({super.key, required this.vendorWiseOrderList});

  @override
  State<VendorWithinUserOrderPackage> createState() => _VendorWithinUserOrderPackageState();
}

class _VendorWithinUserOrderPackageState extends State<VendorWithinUserOrderPackage> {
  
  List vendorList = [];
  List<dynamic> listOfOrderVendorWise = [];

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
     for(String key in widget.vendorWiseOrderList.keys){
      vendorList.add(key);
      listOfOrderVendorWise.add(widget.vendorWiseOrderList[key]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Orders")),
        backgroundColor: Colors.blue,
       
      ),

      body: ListView.builder(
        itemCount: vendorList.length,
        itemBuilder: (context,Index){
          return GestureDetector(
            onTap: (){
              
              print(vendorList);
    print(listOfOrderVendorWise);
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderWithinOrderPackagePage(ordersOfSelectedVendor: listOfOrderVendorWise[Index],)));
            },

            child: ListTile(
              title: Text(vendorList[Index]), 
            ),
          );
        }
        ),
    );
  }
}