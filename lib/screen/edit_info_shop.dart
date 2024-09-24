import 'dart:convert';
import 'dart:io';

import 'package:ballfoodpanda/model/user_model.dart';
import 'package:ballfoodpanda/utility/id_generator.dart';
import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  const EditInfoShop({super.key});

  @override
  State<EditInfoShop> createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel? userModel;
  String? nameShop, address, phone, urlPicture;
  Location location = Location();
  double? lat, lng;
  File? file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    findLatLng();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("Id");
    String url =
        '${MyConstant().domain}/UngPhp4/getUserWhereId.php?isAdd=true&id=$id';
    print('read data user url = $url');

    try {
      await Dio().get(url).then((value) {
        print('value = $value');
        var result = jsonDecode(value.data);
        print('result json = $result');
        for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
            nameShop = userModel!.nameShop;
            address = userModel!.address;
            phone = userModel!.phone;
            urlPicture = userModel!.urlPicture;
          });
          print('nameShop = ${userModel!.nameShop}');
        }
      });
    } catch (e) {
      print('Error >>>>>>>>>  read data user $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไข รายละเอียดร้าน'),
      ),
      body: userModel == null ? MyStyle().showProgress() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            nameShopForm(),
            showImage(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );

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

  Widget editButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.edit,
          size: 18,
          color: Colors.white,
        ),
        style: MyStyle().raisedButtonStyle,
        onPressed: () {
          confirmDialog();
        },
        label: Text(
          'บันทึกการแก้ไข',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจว่าจะแก้ไขรายเอียดร้านใช่หรือไม่?'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('ตกลง'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    String nameFile = 'shop${IdGenerator().idGenerator()}.jpg';
    String urlUpload = '${MyConstant().domain}/UngPhp4/saveShop.php';
    print('upload image url......$urlUpload');

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    await Dio().post(urlUpload, data: formData).then((value) async {
      print('Response upload ===>> $value');
      urlPicture = '/UngPhp4/Shop/$nameFile';
      print('urlImage = $urlPicture');

      String? id = userModel!.id;
      String url =
          '${MyConstant().domain}/UngPhp4/editUserWhereId.php?isAdd=true&id=$id&name_shop=$nameShop&address=$address&phone=$phone&url_picture=$urlPicture&lat=$lat&lng=$lng';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถเชื่อต่อกับเซิฟเวอร์ได้ กรุณาลองใหม่');
      }
    });
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
            title: 'ร้านอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat!, lng!),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        markers: currentMarker(),
        onMapCreated: (controller) {},
      ),
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                },
                icon: Icon(Icons.add_a_photo)),
            Container(
              width: 250.0,
              height: 200.0,
              child: file == null
                  ? Image.network('${MyConstant().domain}${urlPicture}')
                  : Image.file(file!),
            ),
            IconButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                },
                icon: Icon(Icons.add_photo_alternate)),
          ],
        ),
      );

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

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value.trim(),
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อร้าน'),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value.trim(),
              initialValue: address,
              maxLines: 3,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value.trim(),
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์โทร'),
            ),
          ),
        ],
      );
}
