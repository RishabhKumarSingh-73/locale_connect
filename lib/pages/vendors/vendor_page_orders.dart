import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/services/firestore.dart';
import 'package:rishis_locale_connect/services/order_firestore_services.dart';

class VendorsOrdersPage extends StatefulWidget {
  const VendorsOrdersPage({super.key});

  @override
  State<VendorsOrdersPage> createState() => _VendorsOrdersPageState();
}

class _VendorsOrdersPageState extends State<VendorsOrdersPage> {
  FirestoreService firestoreServices = FirestoreService();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;

  void logout(){
    FirebaseAuth.instance.signOut();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("orders")),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            logout();
          }, icon: Icon(Icons.logout))
        ],
      ),

      body: StreamBuilder(
        stream: firestoreServices.getVendor(currentUser), 
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching products'));
              } 

              List<dynamic> currentVendorsPackageOrders = snapshot.data!.get('orders');

              return ListView.builder(
                itemCount: currentVendorsPackageOrders.length,
                itemBuilder: (context,Index){
                  return GestureDetector(

                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=> ParticularOrdersWithinOrdersVendorPage(ordersToDisplay: currentVendorsPackageOrders[Index]['ordersDetails'],outerIndex: Index, buyer: currentVendorsPackageOrders[Index]['buyerId']))),
                child: ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text(currentVendorsPackageOrders[Index]['orderId']),
                  subtitle: Column(
                    children: [
                      if(currentVendorsPackageOrders[Index]['overallOrderStatus']=='cancelled') ...[
                        
                      Text("cancelled")
                      ]
                      else...[
                        Text("date&time: ${currentVendorsPackageOrders[Index]['dateTime'].toString()}"),
                      Text("totalOrderValue: ${currentVendorsPackageOrders[Index]['totalOrderValue']}"),
                      Text("status: ${currentVendorsPackageOrders[Index]['overallOrderStatus']}")
                      ]
                    ],
                  ),
                ),
              );
                }
                );
        }
        ),

    );
  }
}

class ParticularOrdersWithinOrdersVendorPage extends StatefulWidget {
  final List<dynamic> ordersToDisplay;
  final int outerIndex;
  final String buyer;
  const ParticularOrdersWithinOrdersVendorPage({super.key, required this.ordersToDisplay, required this.outerIndex, required this.buyer});

  @override
  State<ParticularOrdersWithinOrdersVendorPage> createState() => _ParticularOrdersWithinOrdersVendorPageState();
}

class _ParticularOrdersWithinOrdersVendorPageState extends State<ParticularOrdersWithinOrdersVendorPage> {
  OrderFirestoreService orderFirestoreServices = OrderFirestoreService();
  String currentUser = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("orders")),
        backgroundColor: Colors.blue,
        
      ),

      body:  ListView.builder(
        itemCount: widget.ordersToDisplay.length,
        itemBuilder: (context,Index){
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.ordersToDisplay[Index]['imageUrl']),
            ),
            title: Text(widget.ordersToDisplay[Index]['productName']),
            subtitle: Column(children: [
                        Text("price: ${widget.ordersToDisplay[Index]['productPrice']}"),
                        Text('Quantity: ${widget.ordersToDisplay[Index]['quantity']}'),
                        Text('status: ${widget.ordersToDisplay[Index]['o.rderStatus']}'),
                      ],),
            trailing: SizedBox(width: 120,
              child: Row(children: [
                IconButton(onPressed: (){
                  orderFirestoreServices.individualProductAcceptance(widget.buyer, currentUser, widget.outerIndex, Index);
                }, icon: Icon(Icons.check)),
                IconButton(onPressed: (){
                  orderFirestoreServices.individualProductRejectance(widget.buyer, currentUser, widget.outerIndex, Index);
                }, icon: Icon(Icons.close))
              ],),
            ),
          );
        }),
    );
  }
}