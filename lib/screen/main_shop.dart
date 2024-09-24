import 'package:flutter/material.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/signout_procress.dart';
import 'package:ballfoodpanda/widget/information_shop.dart';
import 'package:ballfoodpanda/widget/list_food_menu_shop.dart';
import 'package:ballfoodpanda/widget/order_list_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  const MainShop({super.key});

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  String? nameUser;
  Widget currentWidget = OrderListShop();

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString("Name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main Shop' : 'Welcome Shop $nameUser'),
        actions: [
          IconButton(
              onPressed: () {
                signOutProcess(context);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: [
            showHead(),
            homeMenu(),
            foodMenu(),
            informationMenu(),
            signoutMenu()
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('รายการอาหารที่ลูกค้าสั่ง'),
        subtitle: Text('รายการอาหารที่ยังไม่ได้ทำส่งลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        }
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text('รายการอาหาร'),
        subtitle: Text('รายการอาหารของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ListFoodMenuShop();
          });
          Navigator.pop(context);
        }
      );
  ListTile informationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('แก้ไขรายละเอียดของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = InformationShop();
          });
          Navigator.pop(context);
        }
      );
  ListTile signoutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign out'),
        subtitle: Text('ออกจากระบบ กลับไปหน้าแรก'),
        onTap: () => signOutProcess(context),
      );
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('images/shop.jpg'),
        currentAccountPicture: MyStyle().ShowLogo(),
        accountName: Text(
          'Name Login',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail:
            Text('Login', style: TextStyle(color: MyStyle().darkColor)));
  }
}
