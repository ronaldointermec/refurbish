import 'package:flutter/material.dart';
import 'package:refurbish_web/builder/mobile/CounterBuider.dart';
import 'package:refurbish_web/manager/mobile/ShipmentManager.dart';
import 'package:refurbish_web/main.dart';

class ShipmentCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShipmentManager manager = context.fetch<ShipmentManager>();
    return CounterBuider(
      stream: manager.browse$,
      builder: (context, shipmentList) {
        return Chip(
          padding: EdgeInsets.all(8.0),
          label: Text(
            shipmentList.length.toString(),
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue[700],
        );
      },
    );
  }
}
