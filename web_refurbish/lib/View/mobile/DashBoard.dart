import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refurbish_web/View/cadastro/PartLocalizationRegister.dart';
import 'package:refurbish_web/View/mobile/CustomSearchDelegate.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/CardCustomizado.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:refurbish_web/theme/theme.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => /*Responsive.isDesktop(context) ? true : */ false,
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        appBar: Responsive.isMobile(context)
            ? AppBarCostumizada(
                title: "Mobile - DashBoard",
                exibeMenu: false,
              )
            : null,
        drawer: AppDrawer(),
        body: Container(
          child: Stack(
            children: [
              Container(
                height: size.height * .25,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          primary: false,
                          crossAxisCount: 3,
                          children: [
                            CardCustomizado(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             Alocacao()));
                                Navigator.pushNamed(context, "/alocacao");
                              },
                              icon: FontAwesomeIcons.cartArrowDown,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: 'Alocar OS',
                              height: 55,
                            ),
                            CardCustomizado(
                              onTap: () {
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate());
                              },
                              icon: FontAwesomeIcons.searchLocation,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: "Exp - Consulta",
                              height: 55,
                            ),
                            CardCustomizado(
                              onTap: () {
                          Navigator.pushNamed(context, "/remover");
                              },
                              icon: FontAwesomeIcons.eraser,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: "Lab - Remover",
                              height: 55,
                            ),
                            CardCustomizado(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: Responsive.isMobile(context)
                                          ? AppBarCostumizada(
                                              title: "Cadastro - Alocação",
                                            )
                                          : null,
                                      drawer: AppDrawer(),
                                      body: PartLocalizationRegister(),
                                    ),
                                  ),
                                );


                              },
                              icon: FontAwesomeIcons.database,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: "Alocar PN",
                              height: 55,
                            ),
                            CardCustomizado(
                              onTap: () {
                                showAboutDialog(
                                    applicationName: 'Reburbish',
                                    applicationVersion: Global.version,
                                    applicationIcon:
                                        Icon(Icons.ad_units_outlined),
                                    applicationLegalese:
                                        'Aplicação para controle de Spare Parts recondicionadas.' +
                                            '\nBy Honeywell BR92',
                                    context: context);
                              },
                              icon: FontAwesomeIcons.infoCircle,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: "Sobre",
                              height: 55,
                            ),
                            CardCustomizado(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LabAlocar()));
                              },
                              icon: Icons.more_horiz,
                              color: AppTheme.scaffoldBackgroundColor,
                              text: "mais",
                              height: 55,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
