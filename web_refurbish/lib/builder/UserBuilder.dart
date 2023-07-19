import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/User.dart';

class UserBuilder extends StatelessWidget {
  final Stream<User> stream;
  final Function builder;

  const UserBuilder({Key key, this.builder, this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<User>(
    stream: this.stream,
    onSuccess: (context, User data) => builder(context,  data ),
    onError: (context, err) => print(err),
    onWaiting: (context) => LinearProgressIndicator()
  );
}
