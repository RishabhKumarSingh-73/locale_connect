import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/customers/customer_home_page.dart';
import 'package:rishis_locale_connect/pages/customers/customer_start_page.dart';
import 'package:rishis_locale_connect/pages/login_page.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_home_page.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_start_page.dart';

class RoleBasedPage extends StatelessWidget {
  const RoleBasedPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(user?.email).get(), 
        builder: (context,snapshots){
              if(snapshots.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if(snapshots.hasError){
                return Text('Error');
              }
              if(snapshots.hasData){
                var data = snapshots.data!.data() as Map<String,dynamic>;
                if(data['is_vendor'] == true){
                  return VendorAccount();
                }
              else return CustomerStart();
              }
              else return Text("nodata");
        }),
    );
  }
}