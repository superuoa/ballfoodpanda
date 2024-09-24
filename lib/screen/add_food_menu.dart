import 'dart:io';

import 'package:ballfoodpanda/utility/id_generator.dart';
import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  const AddFoodMenu({super.key});

  @override
  State<AddFoodMenu> createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File? file;
  String? name, price, detail,urlImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการอาหารของร้าน'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showTitleFood('รูปอาหาร'),
            groupImage(),
            showTitleFood('รายละเอียดอาหาร'),
            nameForm(),
            MyStyle().mySizebox(),
            priceForm(),
            MyStyle().mySizebox(),
            detailForm(),
            MyStyle().mySizebox(),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.save,
          size: 18,
          color: Colors.white,
        ),
        style: MyStyle().raisedButtonStyle,
        onPressed: () {
          if(file == null){
            normalDialog(context, 'กรุณาเลือกรูปภาพอาหาร');
          } else if(name == null || name!.isEmpty || price == null || price!.isEmpty || detail == null || detail!.isEmpty){
            normalDialog(context, 'กรุณาข้อมูลให้ครบทุกช่อง');
          } else {
            uploadImageAndInsertData();
          }
          

        },
        label: Text(
          'บันทึก รายการ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> uploadImageAndInsertData() async {
    print('upload image running......');

    String nameImage = 'shop${IdGenerator().idGenerator()}.jpg';
    String urlUpload = '${MyConstant().domain}/UngPhp4/uploadImageFood.php';
    print('upload image url......$urlUpload');
    print('upload image nameImage......$nameImage');
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) {
        print('Response ===>> $value');
        urlImage = '/UngPhp4/Food/$nameImage';
        print('urlImage = $urlImage');
        insertDataFood();
      });
    } catch (e) {
      print('error $e');
    }
  }

  Future<Null> insertDataFood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("Id");

    String url =
        '${MyConstant().domain}/UngPhp4/insertFoodData.php?isAdd=true&id_shop=$id&name_food=$name&path_image=$urlImage&price=$price&detail=$detail';
    print('edituser url $url');
    try {
      await Dio().get(url).then((value) {
        print('Response edit user ===>> $value');
        if (value.toString() == 'true') {
          Navigator.pop(context);
        } else {
          normalDialog(context, 'ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่');
        }
      });
    } catch (e) {
      print('error edit user $e');
    }
  }

  Widget nameForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: 'ชื่ออาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => price = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: 'ราคาอาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detailForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: 'รายละเอียดอาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
          icon: Icon(Icons.add_a_photo),
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: file == null
              ? Image.asset('images/foodicon.png')
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
          icon: Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {
      print('Error chooseImage $e');
    }
  }

  Widget showTitleFood(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          MyStyle().ShowTitleH2(string),
        ],
      ),
    );
  }
}
