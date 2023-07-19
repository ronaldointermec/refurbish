import 'package:flutter/material.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';

import 'PartLocalization.dart';

class PartLocalizationDataSourceRight extends DataTableSource {
  final List<PartLocalization> partLocalizations;

  PartLocalizationManager manager;

  PartLocalizationDataSourceRight(this.partLocalizations, this.manager);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= partLocalizations.length) return null;
    final PartLocalization partLocalization = partLocalizations[index];
    return DataRow.byIndex(
        index: index,
        selected: partLocalization.isSelected,
        onSelectChanged: (bool value) {
          if (partLocalization.isSelected != value) {
            // _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            partLocalization.isSelected = value;
            this.partLocalizations.removeAt(index);
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text(partLocalization.part.pn, maxLines: 1)),
          DataCell(Text(
            partLocalization.localization.address,
            maxLines: 1,
          )),
          DataCell(Text(
            partLocalization.part.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => partLocalizations.length;

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
        'LOCAL',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'DESC',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  ];
}
