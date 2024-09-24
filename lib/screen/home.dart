import 'package:flutter/material.dart';
import 'package:ballfoodpanda/screen/main_rider.dart';
import 'package:ballfoodpanda/screen/main_shop.dart';
import 'package:ballfoodpanda/screen/main_user.dart';
import 'package:ballfoodpanda/screen/signin.dart';
import 'package:ballfoodpanda/screen/signup.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString('ChooseType');
      if (chooseType!.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainUser());
        } else if (chooseType == 'Shop') {
          routeToService(MainShop());
        } else if (chooseType == 'Rider') {
          routeToService(MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {
      e.toString();
    }
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: ShowDrawer(),
    );
  }

  Drawer ShowDrawer() => Drawer(
        child: ListView(
          children: <Widget>[ShowHeaderDrawer(), SignInMenu(), SignUpMenu()],
        ),
      );

  ListTile SignInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign In'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile SignUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader ShowHeaderDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('images/guest.jpg'),
        currentAccountPicture: MyStyle().ShowLogo(),
        accountName: Text('Guest'),
        accountEmail: Text('Please Login'));
  }

  
}
