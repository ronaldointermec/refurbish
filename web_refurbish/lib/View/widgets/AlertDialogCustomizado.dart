import 'package:flutter/material.dart';

class AlertDialogCustomizado extends StatelessWidget {
  final VoidCallback onPressedSim;
  final VoidCallback onPressedNao;
  final String content;
  final String title;
  final String childSim;
  final String childNao;
  final Widget widget;

  const AlertDialogCustomizado(
      {Key key,
      this.onPressedSim,
      this.onPressedNao,
      this.title,
      this.content,
      this.childSim,
      this.childNao,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
        return (this.widget);
      }),
      actions: [
        TextButton(onPressed: onPressedSim, child: Text(childSim)),
        TextButton(onPressed: onPressedNao, child: Text(childNao))
      ],
    );
  }
}
