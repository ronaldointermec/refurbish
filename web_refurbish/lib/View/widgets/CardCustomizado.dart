import 'package:flutter/material.dart';

class CardCustomizado extends StatelessWidget {
  final Color color;
  final String text;
  final double height;
  final GestureTapCallback onTap;
  final IconData icon;

  const CardCustomizado(
      {Key key,
      @required this.color,
      @required this.text,
      @required this.height,
      this.onTap,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardTextStyle = TextStyle(
        //fontFamily: Global.fontMontserratRegular,
        fontSize: 12,
        color: Color.fromRGBO(63, 63, 63, 1));
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              this.icon,
              size: 50,
              color: this.color,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              this.text,
              style: cardTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
