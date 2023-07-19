import 'package:flutter/material.dart';
import 'package:refurbish_web/View/cadastro/LocalizationRegister.dart';
import 'package:refurbish_web/View/cadastro/PartLocalizationRegister.dart';
import 'package:refurbish_web/View/cadastro/PartRegister.dart';
import 'package:refurbish_web/View/cadastro/FormViewCadastro.dart';
import 'package:refurbish_web/View/cadastro/ReasonRegister.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/widgets.dart';
// import 'package:refurbish_web/builder/ms/RequisitionBuilderMs.dart';
// import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';
import 'package:refurbish_web/theme/theme.dart';
// import 'package:refurbish_web/main.dart';

class AppBarCostumizada extends StatelessWidget with PreferredSizeWidget {
  final String title;
  bool exibeMenu;

  AppBarCostumizada({Key key, this.title, this.exibeMenu = true})
      : super(key: key);

  static const menuItems = <String>[
    'Alocação',
    'PartNumber',
    'Local',
    'Motivo',
  ];

  static const menuItemsMobile = <String>[
    //'Alocação',
    'PartNumber',
    'Local',
  ];

  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final List<PopupMenuItem<String>> _popUpMenuItemsMobile = menuItemsMobile
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    // RequisitionManagerMs manager = context.fetch<RequisitionManagerMs>();
    // manager.inFilter.add("");
    return AppBar(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(this.title),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Abrir Menu de navegação',
              icon: Icon(Icons.menu));
        },
      ),

      actions: [
        // Responsive.isDesktop(context)
        //     ? RequisitionBuilderMs(
        //         stream: manager.browse$,
        //         builder: (context, requisitions) {
        //           return GestureDetector(
        //             onTap: () {
        //               showSearch(
        //                   context: context, delegate: CustomSearchDelegateMs());
        //             },
        //             child: Chip(
        //               label: Text(
        //                 requisitions.length.toString(),
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.red),
        //               ),
        //               backgroundColor: Colors.blue[100],
        //             ),
        //           );
        //         },
        //       )
        //     : SizedBox.shrink(),
        Responsive.isDesktop(context)
            ? PopupMenuButton<String>(
                tooltip: "Cadastro",
                icon: Icon(Icons.app_registration),
                onSelected: (String newValue) {
                  if (newValue == 'PartNumber') {
                    showDialog(
                        context: context,
                        builder: (context) => Responsive.isDesktop(context)
                            ? FormViewCadastro(
                                child: PartRegister(),
                                title: "Cadastro - PartNumber",
                              )
                            : SizedBox.shrink());
                  } else if (newValue == 'Local') {
                    showDialog(
                        context: context,
                        builder: (context) => Responsive.isDesktop(context)
                            ? FormViewCadastro(
                                child: LocalizationRegister(),
                                title: "Cadastro - Local",
                              )
                            : SizedBox.shrink());
                  } else if (newValue == 'Alocação') {
                    showDialog(
                        context: context,
                        builder: (context) => Responsive.isDesktop(context)
                            ? FormViewCadastro(
                                child: PartLocalizationRegister(),
                                title: "Cadastro - Alocação",
                              )
                            : SizedBox.shrink());
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => Responsive.isDesktop(context)
                            ? FormViewCadastro(
                                child: ReasonRegister(),
                                title: "Cadastro - Motivo",
                              )
                            : SizedBox.shrink());
                  }
                },
                itemBuilder: (BuildContext context) => _popUpMenuItems,
              )
            : PopupMenuButton<String>(
                tooltip: "Cadastro",
                icon: exibeMenu
                    ? Icon(Icons.app_registration)
                    : SizedBox.shrink(),
                onSelected: (String newValue) {
                  if (newValue == 'PartNumber') {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  drawer: Responsive.isMobile(context)
                                      ? AppDrawer()
                                      : null,
                                  appBar: Responsive.isMobile(context)
                                      ? AppBarCostumizada(
                                          title: "Cadastro - PartNumber",
                                        )
                                      : null,
                                  body: PartRegister(),
                                )));
                    PartRegister();
                  } else if (newValue == 'Local') {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  drawer: Responsive.isMobile(context)
                                      ? AppDrawer()
                                      : null,
                                  appBar: Responsive.isMobile(context)
                                      ? AppBarCostumizada(
                                          title: "Cadastro - Local",
                                        )
                                      : null,
                                  body: LocalizationRegister(),
                                )));
                  }
                  // else if (newValue == 'Alocação') {
                  //   Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => Scaffold(
                  //                 drawer: Responsive.isMobile(context)
                  //                     ? AppDrawer()
                  //                     : null,
                  //                 appBar: Responsive.isMobile(context)
                  //                     ? AppBarCostumizada(
                  //                         title: "Cadastro - Alocação",
                  //                       )
                  //                     : null,
                  //                 body: PartLocalizationRegister(),
                  //               )));
                  // }
                  // else {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => Scaffold(
                  //                 appBar: AppBarCostumizada(
                  //                   title: "Cadastro - Motivo",
                  //                 ),
                  //                 body: ReasonRegister(),
                  //               )));
                  // }
                },
                itemBuilder: (BuildContext context) => _popUpMenuItemsMobile,
              ),
      ], //Image.asset('assets/images/logo.png',fit: BoxFit.fitHeight,width: 200,),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
