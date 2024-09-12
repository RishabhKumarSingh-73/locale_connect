import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/customers/customer_home_page.dart';
import 'package:rishis_locale_connect/pages/intropage.dart';
import 'package:rishis_locale_connect/pages/rolebased.dart';
import 'package:rishis_locale_connect/services/firestore.dart';

class HomeOrIntro extends StatefulWidget {
  const HomeOrIntro({super.key});

  @override
  State<HomeOrIntro> createState() => _HomeOrIntroState();
}

class _HomeOrIntroState extends State<HomeOrIntro> {

    FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context,snapshot){
          if(snapshot.hasData){
            print(snapshot.data!.email);
            return RoleBasedPage();
          }
          else{
            return IntroPage();
          }
        }
        ),
    );
  }
}