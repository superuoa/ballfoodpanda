import 'dart:convert';

import 'package:ballfoodpanda/model/user_model.dart';
import 'package:ballfoodpanda/screen/edit_info_shop.dart';
import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:ballfoodpanda/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ballfoodpanda/screen/add_info_shop.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  const InformationShop({super.key});
  @override
  State<InformationShop> createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
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
    return Stack(
      children: [
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameShop!.isEmpty
                ? showNodata(context)
                : showListInfoShop(),
        addAndEditButton(),
      ],
    );
  }

  Widget showListInfoShop() => Column(
        children: [
          MyStyle().ShowTitle('รายละเอียดร้าน ${userModel!.nameShop}'),
          showImage(),
          Row(
            children: [
              MyStyle().ShowTitle('ที่อยู่ของร้าน'),
            ],
          ),
          Row(
            children: [
              Text(userModel!.address ?? ''),
            ],
          ),
          MyStyle().mySizebox(),
          showMap(),
        ],
      );

  Widget showImage() {
    
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}${userModel!.urlPicture}'),
    );
  }

  Widget showMap() {
    double lat = double.parse(userModel!.lat ?? '0');
    double lng = double.parse(userModel!.lng ?? '0');
    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) => {},
        markers: shopMarker(),
      ),
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('shopID'),
        position: LatLng(
          double.parse(userModel!.lat ?? '0'),
          double.parse(userModel!.lng ?? '0'),
        ),
        infoWindow: InfoWindow(
            title: 'ร้านของ ${userModel!.nameShop}',
            snippet:
                'ละติจูด = ${userModel!.lat}, ลองติจูด = ${userModel!.lng}'),
      )
    ].toSet();
  }

  Widget showNodata(BuildContext context) {
    return MyStyle()
        .titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูลด้วยครับ');
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  routeToAddinfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddinfo() {
    Widget widget = userModel!.nameShop!.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser(),);
  }
}
