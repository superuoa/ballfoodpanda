import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;

  Container ShowLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget titleCenter(BuildContext context, String str) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          str,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Text ShowTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24.0, color: Colors.blue, fontWeight: FontWeight.bold),
      );

  Text ShowTitleH2(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold),
      );

  TextStyle mainTitle = TextStyle(
      fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold);

  TextStyle mainH2Title = TextStyle(
      fontSize: 16.0, color: Colors.green, fontWeight: FontWeight.bold);

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    minimumSize: Size(88, 45),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(image: AssetImage(namePic), fit: BoxFit.cover));
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
