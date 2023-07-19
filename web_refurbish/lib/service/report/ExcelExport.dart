import 'dart:io';
import 'package:flutter/material.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class ExcelExport {
  static Future<void> pecaSolicitadaEntrega(
      List<PecaSolicitadaEntregue> requisicao, String incio, String fim) async {
    final String letra = 'ABCDEFGHIJ';
    final List<Object> titulo = [
      'PN',
      'DESC',
      'LOCAL',
      'CRIADO EM',
      'ATUALIZADO EM',
      'CRIADO POR',
      'ATUALIZADO POR',
      'OS',
      'MOTIVO',
      'STATUS'
    ];

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

//Defining Gloabl style to the Header.
    Style globalStyle = workbook.styles.add('style');
//set font size.
    globalStyle.fontSize = 12;
//set font bold.
    globalStyle.bold = true;
//set back color by RGB value.
    globalStyle.backColorRgb = Color.fromARGB(245, 22, 44, 144);
//set font color by RGB value.
    globalStyle.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(255, 44, 200, 44);

    for (int i = 0; i < titulo.length; i++) {
      sheet.getRangeByName('${(letra[i])}2').setText(titulo[i].toString());
      sheet.getRangeByName('${(letra[i])}2').cellStyle = globalStyle;
    }

    //Defining a New Gloabl style to de cells.
    globalStyle = workbook.styles.add('style1');
//set font size.
    globalStyle.fontSize = 10;
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(169, 169, 169, 169);

    sheet.getRangeByName('B1').setText('Período de: $incio a $fim');
    sheet.getRangeByName('B1').cellStyle = globalStyle;

    String getItemEstoque({String letra, int index}) {
      switch (letra) {
        case 'A':
          return requisicao[index].pn;
          break;
        case 'B':
          return requisicao[index].description;
          break;
        case 'C':
          return requisicao[index].address;
          break;
        case 'D':
          return requisicao[index].created_at;
          break;
        case 'E':
          return requisicao[index].updated_at;
          break;
        case 'F':
          return requisicao[index].created_by;
          break;
        case 'G':
          return requisicao[index].updated_by;
          break;
        case 'H':
          return requisicao[index].os;
          break;
        case 'I':
          return requisicao[index].reason;
          break;
        case 'J':
          return requisicao[index].status;
          break;
      }
    }

    for (int index = 0; index < requisicao.length; index++) {
      for (int j = 0; j < letra.length; j++) {
        sheet
            .getRangeByName('${letra[j]}${index + 3}')
            .setText(getItemEstoque(letra: letra[j], index: index));

        sheet.getRangeByName('${letra[j]}${index + 3}').cellStyle = globalStyle;

        // AutoFit applied to a single row
        sheet.autoFitRow(index + 1);
        // AutoFit applied to a single Column.
        sheet.autoFitColumn(index + 1);
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Posicão de Estoque ${DateTime.now()}.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }

  static Future<void> posicaoEstoque(
      List<PosicaoEstoque> estoque, String incio, String fim) async {
    final String letra = 'ABCDE';
    final List<Object> titulo = ['PN', 'DESC', 'LOCAL', 'QTD', 'STATUS'];
    //final List<PosicaoEstoque> estoque = await PosicaoEstoqueService.browse();

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

//Defining Gloabl style to the Header.
    Style globalStyle = workbook.styles.add('style');
//set font size.
    globalStyle.fontSize = 12;
//set font bold.
    globalStyle.bold = true;
//set back color by RGB value.
    globalStyle.backColorRgb = Color.fromARGB(245, 22, 44, 144);
//set font color by RGB value.
    globalStyle.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(255, 44, 200, 44);

    for (int i = 0; i < titulo.length; i++) {
      sheet.getRangeByName('${(letra[i])}2').setText(titulo[i].toString());
      sheet.getRangeByName('${(letra[i])}2').cellStyle = globalStyle;
    }

    //Defining a New Gloabl style to de cells.
    globalStyle = workbook.styles.add('style1');
//set font size.
    globalStyle.fontSize = 10;
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(169, 169, 169, 169);

    sheet.getRangeByName('B1').setText('Período de: $incio a $fim');
    sheet.getRangeByName('B1').cellStyle = globalStyle;

    String getItemEstoque({String letra, int index}) {
      switch (letra) {
        case 'A':
          return estoque[index].pn;
          break;
        case 'B':
          return estoque[index].description;
          break;
        case 'C':
          return estoque[index].address;
          break;
        case 'D':
          return estoque[index].qtd.toString();
          break;
        case 'E':
          return estoque[index].status;
          break;
      }
    }

    for (int index = 0; index < estoque.length; index++) {
      for (int j = 0; j < letra.length; j++) {
        sheet
            .getRangeByName('${letra[j]}${index + 3}')
            .setText(getItemEstoque(letra: letra[j], index: index));

        sheet.getRangeByName('${letra[j]}${index + 3}').cellStyle = globalStyle;

        // AutoFit applied to a single row
        sheet.autoFitRow(index + 1);
        // AutoFit applied to a single Column.
        sheet.autoFitColumn(index + 1);
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Posicão de Estoque ${DateTime.now()}.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}
