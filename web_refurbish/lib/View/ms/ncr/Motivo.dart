import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/model/export.dart';

class Motivo extends StatefulWidget {
  final Map osPN;

  const Motivo({Key key, this.osPN}) : super(key: key);

  @override
  _MotivoState createState() => _MotivoState();
}

class _MotivoState extends State<Motivo> {
  final _formKey = GlobalKey<FormState>();
  bool isDefeituosa = false;
  bool isDanificada = false;

  String _getMotivo() {
    if (this.isDefeituosa)
      return 'defeito';
    else if (this.isDanificada) return 'dano';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBarCostumizada(
        title: "NCR - Motivo",
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: (this.isDanificada || this.isDefeituosa)
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              mini: true,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (_getMotivo() != null) {
                    Navigator.pushNamed(context, "/descricao", arguments: {
                      "os": widget.osPN['os'],
                      "pn": widget.osPN['pn'],
                      "motivo": _getMotivo()
                    });
                  }
                }
              },
            )
          : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: SizedBox(
          width: _width / 2,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      SizedBox(
                        width: 200,
                      ),
                      Expanded(
                        child: new LinearPercentIndicator(
                          // width: 140.0,
                          // lineHeight: 5.0,
                          percent: 0.6,
                          // center: Text(
                          //   "25.0%",
                          //   style: new TextStyle(fontSize: 12.0),
                          // ),
                          // trailing: Icon(Icons.mood),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Qual é o motivo?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                CheckboxListTile(
                    title: Text('Peça defeituosa',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    value: isDefeituosa,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        isDefeituosa = true;
                        isDanificada = false;
                      });
                    }),
                CheckboxListTile(
                    title: Text('Peça danificada no processo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    value: isDanificada,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        isDanificada = true;
                        isDefeituosa = false;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
