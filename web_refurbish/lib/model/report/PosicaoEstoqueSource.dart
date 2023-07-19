import 'package:flutter/material.dart';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';

class PosicaoEstoqueSource extends DataTableSource {
  final List<PosicaoEstoque> posicaoEstoqueList;

  PosicaoEstoqueSource(this.posicaoEstoqueList);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= posicaoEstoqueList.length) return null;
    final PosicaoEstoque posicaoEstoque = posicaoEstoqueList[index];
    return DataRow.byIndex(index: index, selected: false,
        // onSelectChanged: (bool value) async {
        //   if (posicaoEstoque.isSelected != value) {
        //     // _selectedCount += value ? 1 : -1;
        //     assert(_selectedCount >= 0);
        //
        //     notifyListeners();
        //   }
        // },
        cells: <DataCell>[
          DataCell(Text(posicaoEstoque.pn)),
          DataCell(Text(
            posicaoEstoque.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )),
          DataCell(Text(
            posicaoEstoque.address,
            maxLines: 1,
          )),
          DataCell(Text(
            posicaoEstoque.qtd.toString(),
            maxLines: 1,
          )),
          DataCell(Text(
            posicaoEstoque.status,
            maxLines: 1,
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => posicaoEstoqueList.length;

  @override
  int get selectedRowCount => _selectedCount;

  static const dataColumn = <DataColumn>[
    DataColumn(
      label: Text(
        'PN',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'DESC',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'LOCAL',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'QTD',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'STATUS',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  ];
}
