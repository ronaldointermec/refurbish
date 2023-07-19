import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refurbish_web/View/pagar/PagarPageRightEmprestimo.dart';
import 'package:refurbish_web/View/pagar/PagarPageRightRequisicao.dart';
import 'package:refurbish_web/model/export.dart';

class PagarPageRight extends StatelessWidget {
  Requisition req = Get.put(Requisition());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !req.isEmprestimo.value
          ? PagarPageRightRequisicao()
          : PagarPageRightEmprestimo();
    });
  }
}
