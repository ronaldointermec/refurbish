import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:refurbish_web/View/widgets/AlertDialogCustomizado.dart';
import 'package:refurbish_web/builder/EmprestimoItemBuilder.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:get/get.dart';
import 'package:refurbish_web/service/PartLocalizationService.dart';
import 'package:refurbish_web/service/RequisitionService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:refurbish_web/main.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:refurbish_web/model/Requisition.dart';

class PagarPageRightEmprestimo extends StatefulWidget {
  const PagarPageRightEmprestimo({Key key}) : super(key: key);

  @override
  _PagarPageRightEmprestimoState createState() =>
      _PagarPageRightEmprestimoState();
}

class _PagarPageRightEmprestimoState extends State<PagarPageRightEmprestimo> {
  Requisition emprestimo;
  int _indiceAtual = 0;
  double fonteSize = 18;
  Requisition req = Get.put(Requisition());
  List<PartLocalization> partLocalizations = [];

  void _gerarRequisicao(context, manager) {
    if (emprestimo != null && req.isEmprestimo.value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogCustomizado(
            title: 'CONFIRMAÇÃO',
            widget: Text(
                'Deseja gerar requisição ${emprestimo.requisition_number}?'),
            onPressedSim: () async {
              Navigator.pop(context, 'Sim');
              emprestimo.updated_by = await UserService.getUserEidPreferentes();
              int codStatus = await RequisitionService.criar(emprestimo);

              if (codStatus == 200) {
                _showSnackBar("Sucesso ao gerar requisição! ", "Sim");
                manager.inFilter.add('');
                emprestimo = null;
                manager.inEmprestimo.add(emprestimo);
              } else {
                _showSnackBar("Falha ao gerar requisição! ", "Não");
              }
            },
            childSim: 'Sim',
            onPressedNao: () {
              Navigator.pop(context, 'Não');
            },
            childNao: 'Não',
          );
        },
      );
    } else {
      _showSnackBar("Selecione um item! ", "Não");
    }
  }

  void _imprimir(context, manager) async {
    if (emprestimo != null) {
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat pageFormat) async =>
              emprestimo.buildPdf(pageFormat));
    } else {
      _showSnackBar("Selecione um item! ", "Não");
    }
  }

  void _devolver(context, manager) async {
    //  if (emprestimo != null) {
    //
    // int statusCode =  await RequisitionService.update(emprestimo);
    // if(statusCode==200){
    //   _showSnackBar(" Devolvido com sucesso!", "Sim");
    //   emprestimo=null;
    //
    // }else{
    //   _showSnackBar(" Erro ao devolver!", "Não");
    // }
    //
    //  } else {
    //    _showSnackBar("Selecione um item! ", "Não");
    //  }
    if (emprestimo != null && req.isEmprestimo.value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogCustomizado(
            title: 'CONFIRMAÇÃO',
            widget: Text('Deseja realizar devolução?'),
            onPressedSim: () async {
              Navigator.pop(context, 'Sim');
              emprestimo.updated_by = await UserService.getUserEidPreferentes();
              int statusCode = await RequisitionService.update(emprestimo);

              if (statusCode == 200) {
                _showSnackBar("Sucesso ao devolver ao estoque! ", "Sim");
                manager.inFilter.add('');
                emprestimo = null;
                manager.inEmprestimo.add(emprestimo);
              } else {
                _showSnackBar("Falha ao devolver ao estoque!! ", "Não");
              }
            },
            childSim: 'Sim',
            onPressedNao: () {
              Navigator.pop(context, 'Não');
            },
            childNao: 'Não',
          );
        },
      );
    } else {
      _showSnackBar("Selecione um item! ", "Não");
    }
  }

  void _removerItem(int index) async {
    if (emprestimo.partLocalizations.length > 1) {
      //   PartLocalization partLocalization = PartLocalization(
      //       emprestimo.partLocalizations[index].id,
      //       emprestimo.partLocalizations[index].part,
      //       emprestimo.partLocalizations[index].localization);
      //   partLocalization.created_by = await UserService.getUserEidPreferentes();
      //
      //   int statusCode = await PartLocalizationService.update(partLocalization);
      //   if (statusCode == 200) {
      //     _showSnackBar(" Removido com sucesso!", "Sim");
      //     setState(() {
      //       partLocalizations.removeAt(index);
      //     });
      //   } else {
      //     _showSnackBar(" Erro ao remover!", "Não");
      //   }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialogCustomizado(
              title: 'CONFIRMAÇÃO',
              widget: Text(
                  'Deseja remover pn ${emprestimo.partLocalizations[index].part.pn}?'),
              onPressedSim: () async {
                Navigator.pop(context, 'Sim');
                PartLocalization partLocalization = PartLocalization(
                    emprestimo.partLocalizations[index].id,
                    emprestimo.partLocalizations[index].part,
                    emprestimo.partLocalizations[index].localization);
                partLocalization.created_by =
                    await UserService.getUserEidPreferentes();

                int statusCode =
                    await PartLocalizationService.update(partLocalization);
                if (statusCode == 200) {
                  _showSnackBar(" Removido com sucesso!", "Sim");
                  setState(() {
                    partLocalizations.removeAt(index);
                  });
                } else {
                  _showSnackBar(" Erro ao remover!", "Não");
                }
              },
              childSim: 'Sim',
              onPressedNao: () {
                Navigator.pop(context, 'Não');
              },
              childNao: 'Não',
            );
          });
    } else {
      _showSnackBar(" Permitido se houver mais de um item!", "Não");
    }
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
    RequisitionManager manager = context.fetch<RequisitionManager>();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: EmprestimoItemBuilder(
                stream: manager.emprestimo$,
                builder: (context, requisition) {
                  emprestimo = requisition;
                  partLocalizations = requisition.partLocalizations;
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          height: 200,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "REQUISIÇÃO: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.requisition_number.toString(),
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "ATENDIMENTO: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.order.os,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "CONTRATO: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.order.contract_type ?? " ",
                                    style: TextStyle(fontSize: fonteSize),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "CLIENTE: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.order.customer_name ?? " ",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(fontSize: fonteSize),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "EQUIPAMENTO: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.order.part_number ?? " ",
                                    style: TextStyle(fontSize: fonteSize),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "SERIALNUMBER: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fonteSize),
                                  ),
                                  Text(
                                    requisition.order.serial_number ?? " ",
                                    style: TextStyle(fontSize: fonteSize),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Expanded(
                            child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: partLocalizations.length,
                          itemBuilder: (context, index) {
                            Part part = partLocalizations[index].part;
                            Localization localization =
                                partLocalizations[index].localization;
                            return Slidable(
                              key: UniqueKey(),
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              actions: [
                                IconSlideAction(
                                  closeOnTap: false,
                                  caption: 'Remover',
                                  color: Colors.indigo,
                                  icon: Icons.delete_forever_outlined,
                                  onTap: () {
                                    _removerItem(index);
                                  },
                                ),
                              ],
                              child: ListTile(
                                leading: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppTheme.scaffoldBackgroundColor,
                                ),
                                title: Text("PN: ${part.pn}"),
                                trailing: Chip(
                                  label: Text(
                                    localization.address,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      AppTheme.scaffoldBackgroundColor,
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _indiceAtual = index;

            if (_indiceAtual == 0) {
              _gerarRequisicao(context, manager);
            } else if (_indiceAtual == 1) {
              _devolver(context, manager);
            } else {
              _imprimir(context, manager);
            }
          });
        },
        elevation: 0,
        // fixedColor: Colors.white,
        // selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedLabelStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

        backgroundColor: AppTheme.scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_box,
                color: Colors.white,
              ),
              label: 'Gerar Requisição'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_return_outlined,
                color: Colors.white,
              ),
              label: 'Devolver ao Estoque'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            label: 'Imprimir',
          ),
        ],
      ),
    );
  }
}
