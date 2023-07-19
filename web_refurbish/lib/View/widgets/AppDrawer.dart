import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refurbish_web/View/widgets/widgets.dart';
import 'package:refurbish_web/builder/RequisitionBuilder.dart';
import 'package:refurbish_web/builder/UserBuilder.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/manager/UserManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/settings/Global.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserManager manager = context.fetch<UserManager>();
    RequisitionManager requisitionManager = context.fetch<RequisitionManager>();
    requisitionManager.inFilter.add('');


    return Drawer(
      child: Column(
        children: [
          UserBuilder(
            stream: manager.userPreferences$,
            builder: (context, user) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF3C3F54)),
                accountName: Text(user.Name) ?? "",
                accountEmail: Text(user.Username) ?? "",
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              );
            },
          ),
          Responsive.isDesktop(context)
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/pagar");
                  },
                  leading: Icon(FontAwesomeIcons.home),
                  title: Text('Pagar Peça'),
                  trailing: RequisitionBuilder(
                    stream: requisitionManager.browse$,
                    builder: (context, requisitions) {
                      return Chip(
                        label: Text(
                          requisitions.length.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.blue[100],
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
          Responsive.isDesktop(context)
              ? ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/criar");
                  },
                  leading: Icon(FontAwesomeIcons.tasks),
                  title: Text('Requisição'),
                )
              : SizedBox.shrink(),
          Responsive.isDesktop(context)
              ? ExpansionTile(
                  title: Text('Microsiga'),
                  leading: Icon(FontAwesomeIcons.arrowCircleDown),
                  children: [
                    ListTile(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, "/criarms");
                      },
                      leading: Icon(Icons.add),
                      title: Text('Gerar Empréstimo'),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, "/gerarncr");
                      },
                      leading: Icon(Icons.repeat_one_rounded),
                      title: Text('Gerar NCR'),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Responsive.isDesktop(context)
              ? ExpansionTile(
                  title: Text('Relatórios'),
                  leading: Icon(FontAwesomeIcons.chartPie),
                  children: [
                    ListTile(
                      onTap: () async {
                        Navigator.pushReplacementNamed(context, '/requisicao');
                      },
                      //leading: Icon(Icons.description),
                      title: Text('Peças Solicitadas x Entregues'),
                      leading: Icon(FontAwesomeIcons.fileExcel),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, "/estoque");
                      },
                      //leading: Icon(Icons.description),
                      title: Text('Posição de Estoque'),
                      leading: Icon(FontAwesomeIcons.fileExcel),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Responsive.isDesktop(context)
              ? ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/reimpressao");
                  },
                  leading: Icon(FontAwesomeIcons.print),
                  title: Text('Reimpressão'),
                )
              : SizedBox.shrink(),
          Responsive.isDesktop(context)
              ? ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();

                    showAboutDialog(
                        applicationName: 'Reburbish',
                        applicationVersion: Global.version,
                        applicationIcon: Icon(Icons.ad_units_outlined),
                        applicationLegalese:
                            'Aplicação para controle de Spare Parts recondicionadas.' +
                                '\nBy Honeywell BR92',
                        context: context);
                  },
                  leading: Icon(FontAwesomeIcons.infoCircle),
                  title: Text('Sobre'),
                )
              : SizedBox.shrink(),
          Responsive.isMobile(context)
              ? ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, "/ip");
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                )
              : SizedBox.shrink(),
          Divider(),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                onTap: () async {
                  await UserService.deleteUserPreferences();
                  //Navigator.pushReplacementNamed(context, '/');
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                },
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
