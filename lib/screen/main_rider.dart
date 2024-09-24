import 'package:flutter/material.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/signout_procress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {
  const MainRider({super.key});

  @override
  State<MainRider> createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {

  String? nameUser;

  @override
  void initState() {
    super.initState();
    findUser();
  }
  Future<Null> findUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString("Name");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main Rider' : 'Welcome Rider $nameUser'),
        actions: [
          IconButton(
              onPressed: () {
                signOutProcess(context);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: [
            showHead(),
          ],
        ),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('images/rider.jpg'),
        currentAccountPicture: MyStyle().ShowLogo(),
        accountName: Text(
          'Name Login',
          style: TextStyle(color: MyStyle().darkColor),
        ),
        accountEmail:
            Text('Login', style: TextStyle(color: MyStyle().darkColor)));
  }
}