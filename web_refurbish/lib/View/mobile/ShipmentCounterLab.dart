import 'package:flutter/material.dart';
import 'package:refurbish_web/builder/mobile/CounterBuider.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/manager/mobile/ShipmentManagerLab.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';

class ShipmentCounterLab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShipmentManagerLab manager = context.fetch<ShipmentManagerLab>();
    Shipment shipment = Shipment();
    manager.inFilter.add(shipment);
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
