import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function onSuccess;
  final Function onError;
  final Function onWaiting;

  const Observer(
      {/*Key key,*/ this.stream, this.onSuccess, this.onError, this.onWaiting});//: super(key: key);

  Function get _defaultOnWaiting =>
      (contex) => Center(child: CircularProgressIndicator());

  Function get _defaultOnError =>
      (context, error) => Center(child: Text(error));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this.stream,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {


          if (snapshot.hasError) {
            return (onError != null)
                ? onError(context, snapshot.error)
                : _defaultOnError(context, snapshot.error);
          }
          if(snapshot.hasData){
            Object data = snapshot.data;
            return onSuccess(context, data);
          }else{
            return (onWaiting != null)
                ? onWaiting(context)
                : _defaultOnWaiting(context);
          }

        });
  }
}
