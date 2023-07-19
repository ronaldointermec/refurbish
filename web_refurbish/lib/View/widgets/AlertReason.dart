import 'package:flutter/material.dart';
import 'package:refurbish_web/builder/ReasonBuilder.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/manager/ReasonManager.dart';
import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:refurbish_web/model/Reason.dart';
import 'package:refurbish_web/settings/Global.dart';

class AlertReason extends StatefulWidget {
  final PartLocalization partLocalization;

  const AlertReason({Key key, this.partLocalization}) : super(key: key);

  @override
  _AlertReasonState createState() => _AlertReasonState();
}

class _AlertReasonState extends State<AlertReason> {
  bool faltaPeca = false;
  bool diminuirCusto = true;

  bool value = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PartLocalizationManager manager = context.fetch<PartLocalizationManager>();
    ReasonManager reasonManager = context.fetch<ReasonManager>();

    return AlertDialog(
      title: Text(
        'MOTIVO:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
          return SingleChildScrollView(
            child: ReasonBuilder(
              stream: reasonManager.browse$,
              builder: (context, reasons) {
                //List<Reason> reasons = snapshot.data;
                return Container(
                  width: 500,
                  height: 150,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reasons.length,
                      itemBuilder: (context, index) {
                        Reason reason = reasons[index];
                        return ListTile(
                          //   leading: Icon(Icons.indeterminate_check_box),
                          onTap: () {
                            Global.podeAdicionarPN = false;
                            widget.partLocalization.reason_id = reason.id;
                            manager.inPartLocalization
                                .add(widget.partLocalization);

                            Navigator.pop(context, true);
                          },
                          title: Text(
                            reason.description,
                          ),
                          trailing: Icon(
                            Icons.select_all_rounded,
                            color: Colors.blue,
                          ),
                        );
                      }),
                );
              },
            ),
          );
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child:
                Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold)))
      ],
    );
  }
}
