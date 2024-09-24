import 'dart:convert';

import 'package:ballfoodpanda/model/food_model';
import 'package:ballfoodpanda/screen/add_food_menu.dart';
import 'package:ballfoodpanda/utility/my_constant.dart';
import 'package:ballfoodpanda/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  const ListFoodMenuShop({super.key});

  @override
  State<ListFoodMenuShop> createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool status = true;
  bool loadStatus = true;
  List<FoodModel> foodModels =
      List.empty(); // List<ModelClass> modelList=<ModelClass>[];

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        loadStatus ? MyStyle().showProgress() : showContent(),
        addMenuButtom(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFood() {
    return ListView.builder(
      itemCount: foodModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Image.network(
              '${MyConstant().domain}${foodModels[index].pathImage}',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${foodModels[index].nameFood}',
                  style: MyStyle().mainTitle,
                ),
                Text(
                  'ราคา: ${foodModels[index].price} บาท',
                  style: MyStyle().mainH2Title,
                ),
                Text('${foodModels[index].detail}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> readFoodMenu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("Id");

    String url =
        '${MyConstant().domain}/UngPhp4/getFoodWhereShopId.php?isAdd=true&id_shop=$id';
    print('get food data $url');

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      print('get food data $value');

      if (value.toString() != 'null') {
        foodModels = (json.decode(value.data) as List)
            .map((data) => FoodModel.fromJson(data))
            .toList();
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Widget addMenuButtom() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddFoodMenu(),
                    );
                    Navigator.push(context, route).then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
