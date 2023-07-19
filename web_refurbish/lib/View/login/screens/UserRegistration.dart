import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRegistration extends StatefulWidget {
  final double height;
  final double width;

  const UserRegistration({Key key, this.height, this.width}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  _launchURL() async {
    const url = 'https://sites.honeywell.com.br/rdm/SipRequest/Index';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    var regularStyle = TextStyle(
        /*fontFamily: Global.fontMontserratRegular,*/
        fontSize: 12,
        color: Colors.white70);

    return Material(
      elevation: 60.0,
      child: TweenAnimationBuilder(

        duration: Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (BuildContext context, double opacity, Widget widget) {
          return Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.white70,
                color: Color(0xFF262A41),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0.5,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 0.0), // shadow direction: bottom right
                  )
                ],
              ),
              height: this.widget.height,
              width: this.widget.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/honeywell.png',
                    width: MediaQuery.of(context).size.height * .35,
                  ),
                  SizedBox(height: 100 ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'A solicitação de cadastro será realizada '
                                'através do link abaixo \n\n ',
                            style:regularStyle,

                          ),
                          TextSpan(
                            text: 'Clique aqui para solicitar o acesso',
                            style: TextStyle(
                             /* fontFamily: Global.fontMontserratMedium,*/
                              color: Colors.blue,
                              fontSize: 14
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL();
                              },
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
