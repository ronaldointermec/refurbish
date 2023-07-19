import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refurbish_web/View/widgets/TextFormFieldCustomizado.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/settings/Global.dart';

class SearchBar extends StatelessWidget {
  final String mensagemPesquisa;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onFieldSubmitted;

  SearchBar(
      {Key key, this.mensagemPesquisa, this.onChange, this.onFieldSubmitted})
      : super(key: key);

  TextEditingController _controller = TextEditingController();
  Requisition req = Get.put(Requisition());

  @override
  Widget build(BuildContext context) {
    RequisitionManager manager = context.fetch<RequisitionManager>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: TextFormFieldCustomizado(
              controller: _controller,
              mensagemPesquisa: this.mensagemPesquisa,
              onChange: this.onChange,
            )),
        Expanded(
            flex: 1,
            child: Obx(() => SwitchListTile(
                  contentPadding: EdgeInsets.only(right: 8, left: 16),
                  value: req.isEmprestimo.value,
                  onChanged: (value) {
                    req.toggle();
                    Global.isEmprestimo = req.isEmprestimo.value;
                    manager.inFilter.add('');

                    _controller.text = '';
                  },
                  title: Text(
                    'Empréstimo',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                )))
      ],
    );
  }
}
