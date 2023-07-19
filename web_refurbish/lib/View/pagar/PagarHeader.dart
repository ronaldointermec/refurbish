import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/ms/pagar/CustomSearchDelegateMs.dart';
import 'package:refurbish_web/View/ms/pagar/CustomSearchDelegateNcr.dart';
import 'package:refurbish_web/View/widgets/SearchBar.dart';
import 'package:refurbish_web/builder/UserBuilder.dart';
import 'package:refurbish_web/builder/ms/NcrBuilder.dart';
import 'package:refurbish_web/builder/ms/RequisitionBuilderMs.dart';
import 'package:refurbish_web/manager/UserManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/manager/ms/NcrManager.dart';
import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';

class PagarHeader extends StatelessWidget {
  final String mensagemPesquisa;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onFieldSubmitted;

  const PagarHeader(
      {Key key, this.mensagemPesquisa, this.onChange, this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    UserManager manager = context.fetch<UserManager>();

    RequisitionManagerMs managerMs = context.fetch<RequisitionManagerMs>();
    managerMs.inFilter.add("");

    NcrManager managerNcr = context.fetch<NcrManager>();
    managerNcr.inFilter.add("");

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserBuilder(
              stream: manager.userPreferences$,
              builder: (context, user) {
                return Text(
                  'Oi, ${user.Name}',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Bem vindo de volta a estação de trabalho!',
              style: TextStyle(color: Color(0xFF8F919E)),
            ),
            SizedBox(
              height: 15,
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RequisitionBuilderMs(
                  stream: managerMs.browse$,
                  builder: (context, requisitions) {
                    return GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context, delegate: CustomSearchDelegateMs());
                      },
                      child: Column(
                        children: [
                          Container(
                            //margin: EdgeInsets.all(10),
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: colors.first, width: 3)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(colors: colors),
                                  ),
                                  // width: tamanhoMenu(width) ?? 10,
                                  // height: tamanhoMenu(width) ?? 10,
                                  height: 50,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        //_textParts.first[0] + _textParts.last[0],
                                        "Empréstimos Microssiga:   " +
                                            requisitions.length.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: tamanhoFonte(width) ?? 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),





                NcrBuilder(
                  stream: managerNcr.browse$,
                  builder: (context, ncrs) {
                    return GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context, delegate: CustomSearchDelegateNcr());
                      },
                      child: Column(
                        children: [
                          Container(
                            //margin: EdgeInsets.all(10),
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                Border.all(color: colors.first, width: 3)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(colors: colors1),
                                  ),
                                  // width: tamanhoMenu(width) ?? 10,
                                  // height: tamanhoMenu(width) ?? 10,
                                  height: 50,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        //_textParts.first[0] + _textParts.last[0],
                                        "Processo de NCR:   " +
                                            ncrs.length.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: tamanhoFonte(width) ?? 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),


              ],
            ),
            SizedBox(
              height: 15,
            ),
            SearchBar(
              mensagemPesquisa: this.mensagemPesquisa,
              onChange: this.onChange,
              onFieldSubmitted: this.onFieldSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

double tamanhoMenu(double width) {
  if (width > 1180)
    return 90;
  else if (width > 850)
    return 50;
  else
    return null;
}

double tamanhoFonte(double width) {
  if (width > 1180)
    return 18;
  else if (width > 850)
    return 10;
  else
    return null;
}

List<Color> colors = [
  // Colors.primaries[Random().nextInt(Colors.primaries.length)],
  //Colors.primaries[Random().nextInt(Colors.primaries.length)]
  Color(0xFFED6A5A),
  Color(0xFFA40E4C)
];

List<Color> colors1 = [
  Color(0xFF04A777),
  Color(0xFF496DDB)
];
// index % 2 == 0 ? Color(0xFF04A777) : Color(0xFFED6A5A),
// index % 2 == 0 ? Color(0xFF496DDB) : Color(0xFFA40E4C)