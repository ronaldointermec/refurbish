import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:refurbish_web/manager/ms/NcrManager.dart';
import 'package:refurbish_web/model/ms/Ncr.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';
import 'package:refurbish_web/service/PartLocalizationService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/ms/NcrService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:refurbish_web/main.dart';

class Resumo extends StatefulWidget {
  final Map osPNMotivoDesc;

  const Resumo({Key key, this.osPNMotivoDesc}) : super(key: key);

  @override
  _ResumoState createState() => _ResumoState();
}

class _ResumoState extends State<Resumo> {
  final _formKey = GlobalKey<FormState>();
  Order order;
  Part part;
  PartNumberMicrosiga pnms;
  String motivo = '';
  String desc = '';
  String tipo = '';
  int quantidade = 0;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order = widget.osPNMotivoDesc['os'];
    part = widget.osPNMotivoDesc['pn'];
    motivo = widget.osPNMotivoDesc['motivo'];
    desc = widget.osPNMotivoDesc['desc'];
    _consultaEstoque(part.pn);
  }

  _consultaEstoque(String pn) async {
    setState(() {
      this.isLoading = true;
    });
    List<PartNumberMicrosiga> pnMsList =
        await PartLocalizationService.browseMS(pn);
    if (pnMsList.length > 0) {
      setState(() {
        pnms = pnMsList[0];
        this.isLoading = false;
        this.tipo = 'Requisição para troca da peça';
        this.quantidade = pnms.quantity;
      });
    } else {
      setState(() {
        this.isLoading = false;
        this.tipo = 'Requisição somente para devolução da peça';
        this.quantidade = 0;
      });
    }
  }

  Future<bool> _setNCR(context) async {
    Ncr ncr = Ncr(
      motivo: this.motivo,
      desc_problema: this.desc,
      tipo: this.tipo,
      pn: this.part.pn,
      quantidade: pnms == null ? 0 : pnms.quantity,
      desc_pn: this.part.description,
      position: pnms == null ? "Indisponível" : pnms.position ,
      created_by: await UserService.getUserEidPreferentes() ?? "default",
      status_id: 1,
      order: this.order,
    );
    int code = await NcrService.create(ncr);
    if (code == 200) return true;
    return false;
  }

  void _showSnackBar(String text, String ans) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[Text(text)],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    NcrManager manager = context.fetch<NcrManager>();
    return Scaffold(
      appBar: AppBarCostumizada(
        title: "NCR - Resumo",
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: this.isLoading
          ? SizedBox.shrink()
          : FloatingActionButton(
              child: Icon(Icons.check),
              mini: true,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (await _setNCR(context)) {
                    manager.beep.sink.add("");
                    _showSnackBar("Sucesso ao gerar NCR! ", "Sim");
                    Navigator.pushNamedAndRemoveUntil(context, "/pagar", (route) => false);
                  } else {
                    _showSnackBar("Falha ao gerar NCR! ", "Não");
                  }
                }
              },
            ),
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
                if (this.isLoading)
                  CircularProgressIndicator(
                    backgroundColor: AppTheme.scaffoldBackgroundColor,
                  ),
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
                          percent: 1,
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
                  height: 50,
                ),
                Text(
                  'Você está gerando NCR',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                ListTile(
                  title: Text(
                    'OS ${this.order.os}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blue),
                  ),
                  leading: IconButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, "/gerarncr");
                        var nav = Navigator.of(context);
                        nav.pop();
                        nav.pop();
                        nav.pop();
                        nav.pop();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                ),
                ListTile(
                  title: Text(
                    'ParNumber',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  subtitle: Text(
                    this.part.pn + " - " + part.description,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        //Navigator.pushReplacementNamed(context, "/pn");
                        var nav = Navigator.of(context);
                        nav.pop();
                        nav.pop();
                        nav.pop();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Motivo',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  subtitle: Text(
                    this.motivo == 'dano'
                        ? 'Peça danificada no processo'
                        : 'Peça defeituosa',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, "/motivo");
                        var nav = Navigator.of(context);
                        nav.pop();
                        nav.pop();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Descrição do problema',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  subtitle: Text(
                    this.desc,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, "/descricao");
                        var nav = Navigator.of(context);
                        nav.pop();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Tipo',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  subtitle: Text(
                    tipo,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Quantidade em estoque',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  subtitle: Text(
                    this.quantidade.toString() ?? "0",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
