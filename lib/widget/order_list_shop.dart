import 'package:flutter/material.dart';

class OrderListShop extends StatefulWidget {
  const OrderListShop({super.key});

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  @override
  Widget build(BuildContext context) {
    return Text('แสดงรายการอาหาร ที่ลูกค้าสั่ง');
  }
}