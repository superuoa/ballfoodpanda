import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? chooseType, name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            myLogo(),
            MyStyle().mySizebox(),
            showAppName(),
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            userForm(),
            MyStyle().mySizebox(),
            passwordForm(),
            MyStyle().mySizebox(),
            MyStyle().ShowTitleH2('ชนิดของสมาชิก'),
            MyStyle().mySizebox(),
            userRadio(),
            shopRadio(),
            riderRadio(),
            MyStyle().mySizebox(),
            registerButton()
          ],
        ));
  }

  Widget userRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  }),
              Text(
                'ผู้สั่งอาหาร',
                style: TextStyle(color: MyStyle().darkColor),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget shopRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  }),
              Text(
                'เจ้าของร้านอาหาร',
                style: TextStyle(color: MyStyle().darkColor),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget riderRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                  value: 'Rider',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  }),
              Text(
                'ผู้ส่งอาหาร',
                style: TextStyle(color: MyStyle().darkColor),
              )
            ],
          ),
        ),
      ],
    );
  }

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().ShowTitle('Food Panda'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().ShowLogo(),
        ],
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 250.0,
              child: TextField(
                onChanged: (value) => name = value.trim(),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.face, color: MyStyle().darkColor),
                    labelStyle: TextStyle(color: MyStyle().darkColor),
                    labelText: 'Name: ',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyStyle().darkColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyStyle().primaryColor))),
              )),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 250.0,
              child: TextField(
                onChanged: (value) => user = value.trim(),
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.account_box, color: MyStyle().darkColor),
                    labelStyle: TextStyle(color: MyStyle().darkColor),
                    labelText: 'User: ',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyStyle().darkColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyStyle().primaryColor))),
              )),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
              )),
        ],
      );

  Widget registerButton() => Container(
      width: 250.0,
      child: ElevatedButton(
          style: MyStyle().raisedButtonStyle,
          onPressed: () {
            print(
                'name = $name, user = $user, password = $password, chooseType = $chooseType');
            if (name == null ||
                name!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              print('Have Space');
              normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบทุกช่อง');
            } else if (chooseType == null) {
              normalDialog(context, 'กรุณาเลือกชนิดของผู้สมัคร');
            } else {
              checkUser();
            }
          },
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          )));

  Future<Null> checkUser() async {
    String url = '${MyConstant().domain}/UngPhp4/getUserWhereUser.php?user=$user&isAdd=true';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(context, 'user นี้ $user นี้มีอยู่แล้ว กรุณาเปลี่ยน user ใหม่');
      }
    } catch (e) {
      print('ERROR Checkuser $e');
    }
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/UngPhp4/insertUserData.php?name=$name&user=$user&password=$password&chooseType=$chooseType&isAdd=true';
    final dio = Dio();
    try {
      Response response;
      response = await dio.get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'เกิดข้อผิดพลาดบางประการ กรุณาลองใหม่');
      }
    } catch (e) {
      print('Error Register >> $e');
    }
  }
}
