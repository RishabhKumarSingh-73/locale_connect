import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/customers/customer_cart_page.dart';
import 'package:rishis_locale_connect/pages/customers/customer_home_page.dart';
import 'package:rishis_locale_connect/pages/customers/customer_order_page.dart';
import 'package:rishis_locale_connect/pages/customers/customer_profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomerStart extends StatefulWidget {
  const CustomerStart({super.key});

  @override
  State<CustomerStart> createState() => _CustomerStartState();
}

class _CustomerStartState extends State<CustomerStart> {
   List<SalomonBottomBarItem> navbarItemList = [
      SalomonBottomBarItem(icon: Icon(Icons.home), title: Text("home")),
      SalomonBottomBarItem(icon: Icon(Icons.shopping_cart), title: Text("cart")),
      SalomonBottomBarItem(icon: Icon(Icons.shopping_bag), title: Text("orders")),
      SalomonBottomBarItem(icon: Icon(Icons.person), title: Text("profile")),
    ];

    int currentNavbarItem = 0;

    List<Widget> screens = [
      CustomerHomePage(),
      CustomerCartPage(),
      CustomerOrderPage(),
      CustomerProfilePage()
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentNavbarItem],

      bottomNavigationBar: SalomonBottomBar(
        items: navbarItemList,
        currentIndex: currentNavbarItem,
        onTap: (Index)=>{
          setState(() {
            currentNavbarItem = Index;
          })
        },
        
        ),
    );
  }
}