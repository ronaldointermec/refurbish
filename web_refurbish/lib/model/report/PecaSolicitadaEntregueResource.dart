import 'package:flutter/material.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';

class PecaSolicitadaEntregueResource extends DataTableSource {
  final List<PecaSolicitadaEntregue> pecaSolicitadaEntregueList;

  PecaSolicitadaEntregueResource(this.pecaSolicitadaEntregueList);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= pecaSolicitadaEntregueList.length) return null;
    final PecaSolicitadaEntregue pecaSolicitadaEntregue =
        pecaSolicitadaEntregueList[index];
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
          DataCell(Text(pecaSolicitadaEntregue.pn)),
          DataCell(Text(
            pecaSolicitadaEntregue.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )),
          DataCell(Text(pecaSolicitadaEntregue.address)),
          DataCell(Text(
            pecaSolicitadaEntregue.created_at,
            maxLines: 1,
          )),
          DataCell(Text(
            pecaSolicitadaEntregue.updated_at,
            maxLines: 1,
          )),
          DataCell(Text(
            pecaSolicitadaEntregue.created_by,
            maxLines: 1,
          )),
          DataCell(Text(
            pecaSolicitadaEntregue.updated_by ?? "",
            maxLines: 1,
          )),
          DataCell(Text(
            pecaSolicitadaEntregue.os,
            maxLines: 1,
          )),
          DataCell(Text(
            pecaSolicitadaEntregue.reason,
            maxLines: 1,
          )),

          DataCell(Text(
            pecaSolicitadaEntregue.status,
            maxLines: 1,
          )),
          // DataCell(Text(
          //   pecaSolicitadaEntregue.address,
          //   maxLines: 1,
          // )),
          // DataCell(Text(
          //   pecaSolicitadaEntregue.days.toString(),
          //   maxLines: 1,
          // )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pecaSolicitadaEntregueList.length;

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
        'CRIADO EM ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'ATUALIZADO EM',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'CRIADO POR',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'ATUALIZADO POR',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'OS',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'MOTIVO',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'STATUS',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    // DataColumn(
    //   label: Text(
    //     'LOCAL',
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //   ),
    // ),
    // DataColumn(
    //   label: Text(
    //     'DIAS',
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //   ),
    //),
  ];
}
