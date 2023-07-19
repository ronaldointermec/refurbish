import 'package:flutter/material.dart';
import 'package:refurbish_web/View/widgets/AlertReason.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';
import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/settings/Global.dart';

class PartLocalizationDataSourceLeftMs extends DataTableSource {
  final List<PartLocalization> partLocalizations;

  BuildContext context;

  PartLocalizationDataSourceLeftMs(this.partLocalizations, this.context);

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
          PartLocalizationManager manager =
              context.fetch<PartLocalizationManager>();

          assert(_selectedCount >= 0);

          Global.podeAdicionarPN = false;
          // partLocalization.reason_id = 1;
          manager.inPartLocalization.add(partLocalization);

          this.partLocalizations.removeAt(index);
          notifyListeners();
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
