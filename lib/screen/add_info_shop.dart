import 'dart:io';
import 'dart:math';

import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  const AddInfoShop({super.key});

  @override
  State<AddInfoShop> createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  //Field
  double? lat, lng;
  File? file;
  String? nameShop, address, phone, urlImage;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat, lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    return location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Information Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            addressForm(),
            MyStyle().mySizebox(),
            phoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            MyStyle().mySizebox(),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.save,
          size: 18,
          color: Colors.white,
        ),
        style: MyStyle().raisedButtonStyle,
        onPressed: () {
          if (nameShop == null ||
              nameShop!.isEmpty ||
              address == null ||
              address!.isEmpty ||
              phone == null ||
              phone!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else if (file == null) {
            normalDialog(context, 'กรุณาเลือกรูปภาพ');
          } else {
            uploadImage();
          }
        },
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> uploadImage() async {
    print('upload image running......');

    String nameImage = 'shop${idGenerator()}.jpg';
    String url = '${MyConstant().domain}/UngPhp4/saveShop.php';
    print('upload image url......$url');
    print('upload image nameImage......$nameImage');
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);

      await Dio().post(url, data: formData).then((value) {
        print('Response ===>> $value');
        urlImage = '/UngPhp4/Shop/$nameImage';
        print('urlImage = $urlImage');
        editUserShop();
      });
    } catch (e) {
      print('error $e');
    }
  }

  Future<Null> editUserShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("Id");

    String url =
        '${MyConstant().domain}/UngPhp4/editUserWhereId.php?isAdd=true&id=$id&name_shop=$nameShop&address=$address&phone=$phone&url_picture=$urlImage&lat=$lat&lng=$lng';
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

  String idGenerator() {
    final now = DateTime.now();
    Random random = Random();
    int i = random.nextInt(1000000);

    return now.microsecondsSinceEpoch.toString() + i.toString();
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
            title: 'ร้านของคุณ', snippet: 'ละติจูด = $lat, ลองติจูด = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            chooseImages(ImageSource.camera);
          },
          icon: Icon(
            Icons.add_a_photo,
            size: 45.0,
          ),
        ),
        Container(
          width: 250.0,
          child: file == null
              ? Image.asset('images/myimage.png')
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () {
            chooseImages(ImageSource.gallery);
          },
          icon: Icon(
            Icons.add_photo_alternate,
            size: 45.0,
          ),
        ),
      ],
    );
  }

  Future<Null> chooseImages(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => address = value.trim(),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้านค้า',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรร้านค้า',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
