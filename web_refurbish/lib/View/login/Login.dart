import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/login/screens/screens.dart';
import 'package:refurbish_web/View/widgets/widgets.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _LoginScreenMobile(), desktop: _LoginScreenDesktop());
  }
}

class _LoginScreenDesktop extends StatefulWidget {
  @override
  __LoginScreenDesktopState createState() => __LoginScreenDesktopState();
}

class __LoginScreenDesktopState extends State<_LoginScreenDesktop> {
  bool _login = true;

  @override
  void initState() {
    super.initState();
    _login = true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // * .80;
    double width = MediaQuery.of(context).size.width; // * .25;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/illustration.jpg'),
                fit: BoxFit.cover,
              ),
              color: Colors.transparent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: height * .7,
                width: _login ? 0 : (width * .25) / 2,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _login = !_login;
                  });
                },
                child: Opacity(
                  opacity: 0.95,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      // color: Colors.transparent
                    ),
                    height: height * .7,
                    width: (width * .25) / 2,
                    child: Center(
                      child: Center(
                        child: Text(
                          'CADASTRO',
                          style: TextStyle(
                              /* fontFamily: Global.fontMontserratMedium,*/
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.blue,
                height: height * .7,
                width: (width * .25) / 2,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _login = !_login;
                  });
                },
                child: Opacity(
                  opacity: 0.95,
                  child: Container(
                    //color: Colors.transparent,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    height: height * .7,
                    // width: !_login ? width / 2 : 0,
                    width: (width * .25) / 2,
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            /* fontFamily: Global.fontMontserratMedium,*/
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: height - 100,
                width: !_login ? 0 : (width * .25) / 2,
              ),
            ],
          ),
        ),
        _login
            ? UserAuthentication(
                height: height * .8,
                width: width * .25,
              )
            : UserRegistration(
                height: height * .8,
                width: width * .25,
              )
      ],
    );
  }
}

class _LoginScreenMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // * .80;
    double width = MediaQuery.of(context).size.width; // * .25;
    return Scaffold(
      body: SingleChildScrollView(
        child: UserAuthentication(
          height: height,
          width: width,
        ),
      ),
    );
  }
}
