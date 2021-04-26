import 'package:flutter/material.dart';

class PTransaction {
  String id;
  String name;
  String amount;
  String date;
  int isExpense;

  PTransaction.withID(
      this.id, this.name, this.amount, this.date, this.isExpense);

  PTransaction();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date,
      'isExpense': isExpense,
    };
  }

  PTransaction.fromMapObject(
      {@required String id, @required Map<String, dynamic> map}) {
    this.id = map['id'];
    this.name = map['name'];
    this.amount = map['amount'];
    this.date = map['date'];
    this.isExpense = map['isExpense'];
  }
}
