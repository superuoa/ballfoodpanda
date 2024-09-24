import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ballfoodpanda/model/user_model.dart';
import 'package:ballfoodpanda/screen/main_rider.dart';
import 'package:ballfoodpanda/screen/main_shop.dart';
import 'package:ballfoodpanda/screen/main_user.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          colors: <Color>[Colors.white, MyStyle().primaryColor],
          center: Alignment(0, -0.3),
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().ShowLogo(),
                MyStyle().mySizebox(),
                MyStyle().ShowTitle('Food Panda'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => Container(
      width: 250.0,
      child: ElevatedButton(
          style: MyStyle().raisedButtonStyle,
          onPressed: () {
            if (user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              normalDialog(context, 'กรุณากรอก user และ password ให้ครบ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          )));

  Future<Null> checkAuthen() async {
    String url = '${MyConstant().domain}/UngPhp4/getUserWhereUser.php?user=$user&isAdd=true';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      var result = json.decode(response.data);
      print('result = $result');

      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if(chooseType == 'User'){
            routeToService(MainUser(),userModel);
          } else if(chooseType == 'Shop'){
            routeToService(MainShop(),userModel);
          } else if(chooseType == 'Rider'){
            routeToService(MainRider(),userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'password ไม่ถูกต้อง');
        }
      }

    } catch (e) {
      print('catch error : '+e.toString());
    }
  }

  Future<Null> routeToService(Widget myWidget,UserModel userModel) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('Id', userModel.id ?? '');
    preferences.setString('ChooseType', userModel.chooseType ?? '');
    preferences.setString('User', userModel.user ?? '');
    preferences.setString('Name', userModel.name ?? '');
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget,);
    Navigator.pushAndRemoveUntil(context, route, (route) => false,);
  }

  Widget userForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_box, color: MyStyle().darkColor),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User: ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor))),
      ));

  Widget passwordForm() => Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: MyStyle().darkColor),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password: ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor))),
      ));
}
