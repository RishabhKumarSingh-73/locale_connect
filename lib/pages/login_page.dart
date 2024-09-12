import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/register_page.dart';
import 'package:rishis_locale_connect/pages/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    final TextEditingController emailcon = TextEditingController();
    final TextEditingController passwordcon = TextEditingController();

    void login() async{

      showDialog(
        context: context, 
        builder: (context) => CircularProgressIndicator()
        );

      try{
        Navigator.pop(context);
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcon.text, password: passwordcon.text);
        if(context.mounted)Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text(e.code),
            ));
      }
    }

    return Scaffold(

      backgroundColor: Color.fromARGB(255, 251, 206, 237),
      
        body : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 650,
              child: Column(
                children: [
                  
                  SizedBox(height: 150,),
                  
                  Card(
          
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                
                  elevation: 50,
                
                  child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
                    
                    Center(child: Icon(Icons.person,size: 80,color: Colors.pink,)),
                  
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: emailcon, hint: 'email', obscureText: false),
                  
                    SizedBox(height: 10,),
                  
                    MyTextfield(textColor: Colors.pink, borderColor: Colors.pink, controller: passwordcon, hint: 'password', obscureText: true),
                  
                    SizedBox(height: 10,),
                  
                    TextButton(onPressed: (){}, child: Text("Forgot Password?",style: TextStyle(color: Colors.pink,fontSize: 20),)),
                  
                    SizedBox(height: 10,),
                  
                    ElevatedButton(onPressed: () => login(), child: Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),),
                  
                    SizedBox(height: 10,),
                  
                    Text("Dont have an account? ",style: TextStyle(color: Colors.pink,fontSize: 20,),),
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>RegisterPage()));
          
                    }, 
                    child: Text("Register here!!",style: TextStyle(color: Colors.pink,fontSize: 20),)),
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