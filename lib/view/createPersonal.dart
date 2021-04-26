import 'package:flutter/material.dart';

class PersonalTransaction extends StatefulWidget {
  PersonalTransaction({Key key}) : super(key: key);

  @override
  _PersonalTransactionState createState() => _PersonalTransactionState();
}

class _PersonalTransactionState extends State<PersonalTransaction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Personal Transaction Page")),
    );
  }
}
