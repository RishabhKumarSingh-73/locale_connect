import 'package:flutter/material.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_home_page.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_page_analysis.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_page_orders.dart';
import 'package:rishis_locale_connect/pages/vendors/vendor_page_profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class VendorAccount extends StatefulWidget {
  const VendorAccount({super.key});

  @override
  State<VendorAccount> createState() => _VendorAccountState();
}

class _VendorAccountState extends State<VendorAccount> {
   List<SalomonBottomBarItem> navbarItemList = [
      SalomonBottomBarItem(icon: Icon(Icons.home), title: Text("home")),
      SalomonBottomBarItem(icon: Icon(Icons.auto_graph), title: Text("analysis")),
      SalomonBottomBarItem(icon: Icon(Icons.shopping_bag), title: Text("orders")),
      SalomonBottomBarItem(icon: Icon(Icons.person), title: Text("profile")),
    ];
    int currentNavbarItem = 0;

    List<Widget> screens = [
      VendorHomePage(),
      AnalysisPage(),
      VendorsOrdersPage(),
      VendorsProfilePage()
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  screens[currentNavbarItem],

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