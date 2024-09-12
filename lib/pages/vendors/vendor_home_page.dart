import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rishis_locale_connect/pages/textfield.dart';
import 'package:rishis_locale_connect/services/firebase_auth.dart';
import 'package:rishis_locale_connect/services/firestore.dart';


class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
   final GlobalKey<_AddProductCardState> _key = GlobalKey<_AddProductCardState>();
       FirestoreService firestoreservices = FirestoreService();
           String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;



    List productIdList=[];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestoreservices.getCurrentVendor(currentUserEmail).then((value){
      productIdList = value.get('products');
      print(productIdList);
    });
  } 

   


 

  @override
  Widget build(BuildContext context) {
    
    

    FirestoreAuthServices firestoreAuthServices = FirestoreAuthServices();

    

    
    


    

    void addProduct() {
     
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: AddProductCard(),
                
              ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Home"),
        centerTitle: true,
        actions: [IconButton(onPressed: firestoreAuthServices.logout, icon: Icon(Icons.logout))],
      ),



      body: StreamBuilder(
        stream: firestoreservices.getVendor(currentUserEmail), 
        builder: (context,Snapshot){
          if(Snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(Snapshot.hasError)return Text("error");

          if(Snapshot.hasData){

              List myProducts = Snapshot.data!.get('products');

              return ListView.builder(
                itemCount: myProducts.length,
                itemBuilder: (context,Index){

                   Map<String,dynamic> currentProduct = myProducts[Index];
                   final item = myProducts[Index];

                    return ListTile(

                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item['imageUrl']),

                      ),

                      title: Text(item['productName']),
                      subtitle: Text('price: ${item['productPrice']}'),
                      trailing: IconButton(onPressed: (){
                         List? currProdut = _key.currentState?.vendorProducts;
                         currProdut?.remove(item);
                         currProdut == null?currProdut = [] :currProdut;
                         print('${_key.currentState?.vendorProducts}---------');
                        firestoreservices.updateVendorsProduct(currProdut, currentUserEmail);




                      }, icon: Icon(Icons.delete,color: Colors.red,))

                    );

                });

          }
           return Text('nodata');
        } 
        
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => addProduct(),
        child: Icon(Icons.add),
      ),

     
    );
  }
}




class AddProductCard extends StatefulWidget {
  const AddProductCard({super.key});

  @override
  State<AddProductCard> createState() => _AddProductCardState();
}

class _AddProductCardState extends State<AddProductCard> {
    List<dynamic> vendorProducts = [] ;
        String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     FirestoreService firestoreServices = FirestoreService();
      firestoreServices.getCurrentVendor(FirebaseAuth.instance.currentUser!.email).then((value){
        vendorProducts =  value.get('products') ;
      });
  }
  bool isLoading = false;
  var imageUrl;
  final TextEditingController productNamecon = TextEditingController();
    final TextEditingController productPricecon = TextEditingController();



  

   void addProductToFirestore()async{
    FirestoreService firestoreservices = FirestoreService();
    

    
   
      print(vendorProducts);
      vendorProducts.add({
        'productName': productNamecon.text,
        'productPrice':productPricecon.text,
        'imageUrl':imageUrl
      });
      print(vendorProducts);

      
      firestoreservices.updateVendorsProduct(vendorProducts, FirebaseAuth.instance.currentUser!.email);

  }


  @override
  Widget build(BuildContext context) {
    print(vendorProducts);
     
    return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextfield(
                        textColor: Colors.black,
                        borderColor: Colors.grey,
                        controller: productNamecon,
                        hint: 'product name',
                        obscureText: false),
                    MyTextfield(
                        textColor: Colors.black,
                        borderColor: Colors.grey,
                        controller: productPricecon,
                        hint: 'product price',
                        obscureText: false),
                    isLoading ? CircularProgressIndicator(): 
                    IconButton(
                        onPressed: () async {
                          String currentImageName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          ImagePicker imagePicker = ImagePicker();

                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                              if(file != null){
                                setState(() {
                                  isLoading = true;
                                });
                              }

                          print('${file?.path}');

                          Reference rootReference =
                              FirebaseStorage.instance.ref();

                          Reference imageFolderReference =
                              rootReference.child('imag+es');

                          Reference uploadedImageReference =
                              imageFolderReference.child(currentImageName);

                          try {
                            await uploadedImageReference
                                .putFile(File(file!.path));

                              imageUrl = await uploadedImageReference.getDownloadURL();
                              setState(() {
                                isLoading = false;
                              });
                            print(imageUrl);
                          } catch (error) {
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                        },
                        icon: Icon(Icons.add_a_photo)),

                        // IconButton(onPressed: () async{
                        //   Position position = await _determinePosition();
                        //   lat = position.latitude;
                        //   long = position.longitude;
                        //   print("$lat,$long");
                        // }, icon: Icon(Icons.add_location))
                        ElevatedButton(onPressed: (){
                      
                       addProductToFirestore();
                    
                    Navigator.of(context).pop();
                  }
                  , child: Text("data"))
                       
                  ],
                );
  }
}