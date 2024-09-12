import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/login_page.dart';
import 'package:rishis_locale_connect/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

             const Image(image: AssetImage('assets/images/localeConnectLogo.png')),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                elevation: 20,
                backgroundColor: Colors.lightBlueAccent
              ),
              
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));

              },
              
              child:  Text(
                "Login",
                style: Theme.of(context).textTheme.displayMedium,
              )),

              SizedBox(height: 30,),

              ElevatedButton(

                style: ElevatedButton.styleFrom(
                elevation: 20,
                backgroundColor: Colors.lightBlueAccent
              ),
              
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterPage()));
              },
              
              child:  Text(
                "Register",
                style: Theme.of(context).textTheme.displayMedium,
              ))

        ],
      )
      

    );
  }
}