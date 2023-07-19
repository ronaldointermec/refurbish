import 'package:flutter/material.dart';
import 'package:refurbish_web/theme/theme.dart';

class ListaPartNumber extends StatelessWidget {
  final List<Map<String, dynamic>> partNumbers;

  const ListaPartNumber({Key key, this.partNumbers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: 500,
      // height: 500,
      //color: Colors.red,
      child: ListView.separated(
          itemCount: partNumbers.length,
          itemBuilder: (context, index) {
            var _item = partNumbers[index];

            return ListTile(
              leading: Chip(
                label: Text(
                  _item['partNumber'],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppTheme.scaffoldBackgroundColor,
              ),
              title: Text(
                '${_item['descricao']}',
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,

              ),
               //subtitle: Text(' ${_item['quantidade']}', style: TextStyle(fontSize: 10),),
              trailing: Text(
                _item['local'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        separatorBuilder: (context, index) => Divider(),),
    );
  }
}
