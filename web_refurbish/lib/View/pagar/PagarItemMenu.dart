import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/theme/theme.dart';

class PagarItemMenu extends StatelessWidget {
  final bool isSelected;
  final List<Color> colors;
  final String projectName;

  const PagarItemMenu(
      {Key key, this.colors, this.projectName, this.isSelected = false})
      : super(key: key);

  double tamanhoMenu(double width){
    if(width > 1180) return 90;
    else if (width > 850) return 50;
    else return null;

  }

  double tamanhoFonte(double width){
    if(width > 1180) return 18;
    else if (width > 850) return 10;
    else return null;

  }


  @override
  Widget build(BuildContext context) {
    //final _textParts = projectName.split(' ');
    var width = MediaQuery.of(context).size.width;
    return Container(

      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border:/* isSelected
                        ? */Border.all(color: colors.first, width: 3)
                        /*: null*/),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: this.colors),
                      ),
                      width: tamanhoMenu(width) ?? 10,
                      height: tamanhoMenu(width) ?? 10,
                      child: Center(
                        child: Text(

                          //_textParts.first[0] + _textParts.last[0],
                          projectName,
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
              isSelected
                  ? Positioned(
                      top: 11,
                      right: 11,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: AppTheme.scaffoldBackgroundColor,
                                width: 2)),
                      ))
                  : Container(),
            ],
          ),
          //SizedBox(height: 15),
          // Text(
          //   this.projectName ?? '...',
          //   style: TextStyle(color: Color(0xFFC8C8CF)),
          // ),
        ],
      ),
    );
  }
}
