import 'package:flutter/material.dart';
import 'package:refurbish_web/View/widgets/AlertReason.dart';
import 'package:refurbish_web/model/PartLocalization.dart';

class PartLocalizationDataSourceLeft extends DataTableSource {
  final List<PartLocalization> partLocalizations;

  // PartLocalizationManager manager;
  BuildContext context;

  PartLocalizationDataSourceLeft(this.partLocalizations, this.context);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= partLocalizations.length) return null;
    final PartLocalization partLocalization = partLocalizations[index];
    return DataRow.byIndex(
        index: index,
        selected: partLocalization.isSelected,
        onSelectChanged: (bool value) async {
          if (partLocalization.isSelected != value) {
            // _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            partLocalization.isSelected = value;

            if (partLocalization.isSelected) {
              bool isSalvar = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertReason(
                      partLocalization: partLocalization,
                    );
                  });

              if (isSalvar) this.partLocalizations.removeAt(index);
              notifyListeners();
            } else {
              notifyListeners();
            }
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
