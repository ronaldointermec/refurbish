import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/ms/InputCustomizadoMs.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/OrderService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/Validador.dart';

class OrdemServico extends StatefulWidget {
  const OrdemServico({Key key}) : super(key: key);

  @override
  _OrdemServicoState createState() => _OrdemServicoState();
}

class _OrdemServicoState extends State<OrdemServico> {
  final _formKey = GlobalKey<FormState>();
  Order order;
  String os;
  bool isLoading = false;

  Future<bool> _getOrderServico(String os) async {
    setState(() {
      this.isLoading = true;
    });

    List<Order> list = await OrderService.browse(os);
    if (list.length > 0) {
      order = list[0];
      return true;
    }
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
    return Scaffold(
      appBar: AppBarCostumizada(
        title: "NCR - Order de Serviços",
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: this.isLoading ? null : FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        mini: true,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            //processo para recuperar os do microssiga

            if (await _getOrderServico(this.os)) {
              setState(() {
                this.isLoading = false;
              });
              Navigator.pushNamed(context, "/pn", arguments: this.order);
            } else {

              _showSnackBar("Order de serviços ${os} não foi encontrada da base de dados!", "Não");
              setState(() {
                this.isLoading = false;
              });
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
                            Navigator.pushReplacementNamed(context, "/pagar");
                          },
                          icon: Icon(Icons.close)),
                      SizedBox(
                        width: 200,
                      ),
                      Expanded(
                        child: new LinearPercentIndicator(
                          // width: 140.0,
                          // lineHeight: 5.0,
                          percent: 0.2,
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
                  'Para qual OS você quer gerar o NCR?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                //TextFormField(),
                InputCustomizadoMs(
                  controller: null,
                  hint: null,
                  maxLines: 1,
                  validador: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO,
                            msg: 'Obrigatório informar a Ordem de Serviços')
                        .minLength(5, msg: 'mínimo de 5 caracteres')
                        .maxLength(8, msg: 'valor máximo de 8 caracteres')
                        .validar(valor);
                  },
                  onSaved: (os) {
                    this.os = os;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
