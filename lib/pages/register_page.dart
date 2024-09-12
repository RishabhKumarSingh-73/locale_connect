import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rishis_locale_connect/pages/login_page.dart';
import 'package:rishis_locale_connect/pages/textfield.dart';


/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
      bool isVendor = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailcon = TextEditingController();
    final TextEditingController passwordcon = TextEditingController();
    final TextEditingController usernamecon = TextEditingController();
    final TextEditingController confirmpasswordcon = TextEditingController(); 
    final TextEditingController shopnamecon = TextEditingController(); 

    var lat;
    var long;


    void storeVendor(String email,String password,String shopName, bool isVendor) async{
      await FirebaseFirestore.instance.collection('vendors').doc(emailcon.text).set({
        'email': email,
        'password': password,
        'shop_name':shopName,
        'is_vendor':isVendor,
        'lat':lat.toString(),
        'long':long.toString(),
        'products': [],
        'orders':[]
      });
    }

    void storeUsers(String email,String password,bool isVendor) async{
      if(isVendor){
        await FirebaseFirestore.instance.collection('users').doc(emailcon.text).set({
        'email': email,
        'password': password,
        'is_vendor':isVendor,
        'lat':lat.toString(),
        'long':long.toString(),
      });
      }
      else{
        await FirebaseFirestore.instance.collection('users').doc(emailcon.text).set({
        'email': email,
        'password': password,
        'is_vendor':isVendor,
        'orders':[],
        'lat':'',
        'long':'',
      });
      }
    }


    void registerUser() async{

      showDialog(
        context: context, 
        builder: (context) => CircularProgressIndicator()
        );

        if(passwordcon.text != confirmpasswordcon.text){
          Navigator.pop(context);
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text('password and confirm password doesnt match'),
            ));
        }

        else{
          try{
            UserCredential u = await  FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcon.text, password: passwordcon.text);
            
            if(isVendor){
              storeVendor(emailcon.text,passwordcon.text,shopnamecon.text,isVendor);
              storeUsers(emailcon.text,passwordcon.text,isVendor);
            }
            else{
              storeUsers(emailcon.text,passwordcon.text,isVendor);
            }
            Navigator.pop(context);
          } on FirebaseAuthException catch(e){
            Navigator.pop(context);
            showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text(e.code),
            ));
          }
        }
    }




    return Scaffold(

      backgroundColor: Color.fromARGB(255, 251, 206, 237),
      
        body : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 400,
              height: 900,
              child: Column(
                children: [
                  
                  SizedBox(height: 60,),
                  
                  Card(
            
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                
                  elevation: 50,
                
                  child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
                    
                    Center(child: Icon(Icons.person,size: 80,color: Colors.pink,)),
                  //username
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: usernamecon, hint: 'username', obscureText: false),
                  
                    SizedBox(height: 10,),
                  //email
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: emailcon, hint: 'email', obscureText: false),

                    Row(
                      children: [
                        SizedBox(width: 50,),
                        Text("consumer",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.red),),
                        SizedBox(width: 5,),
                        Switch(
                      value: isVendor, 
                      inactiveThumbColor: Colors.red,
                      trackOutlineWidth: WidgetStatePropertyAll(0),
                      inactiveTrackColor: Color.fromARGB(255, 235, 164, 164),
                      activeTrackColor: Color.fromARGB(255, 206, 251, 211),
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          isVendor = value;
                        });
                      }),
                      SizedBox(width: 5,),

                      Text("vendor",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.green),)
                      ],
                    ),

                      if(isVendor)...[
                        SizedBox(height: 10,),
                        
                        MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: shopnamecon, hint: 'Shop name', obscureText: false),
                        
                        SizedBox(height: 10,),
                        IconButton(onPressed: () async{
                          Position position = await _determinePosition();
                          lat = position.latitude;
                          long = position.longitude;
                          print("$lat,$long");
                        }, icon: Icon(Icons.add_location))
                      ],
            
                    SizedBox(height: 10,),
                  //password
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: passwordcon, hint: 'password', obscureText: true),
            
                    SizedBox(height: 10,),
                  //confirm password
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: confirmpasswordcon, hint: 'confirm password', obscureText: false),
                  
                    SizedBox(height: 10,),
                  //forgot password
                    TextButton(onPressed: (){}, child: Text("Forgot Password?",style: TextStyle(color: Colors.pink,fontSize: 20),)),
                  
                    SizedBox(height: 10,),
                  //sign up button
                    ElevatedButton(onPressed: () => registerUser(), child: Text("Sign up",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),),
                  
                    SizedBox(height: 10,),
                  
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Text("Have an account? ",style: TextStyle(color: Colors.pink,fontSize: 15,),),
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));

                      }, 
                      child: Text("Login here!!",style: TextStyle(color: Colors.pink,fontSize: 20),)),
                      ],
                    )
                  ]
                        ),
                ),
              ]),
              
            ),
          ),
        ),

    );
  }
}