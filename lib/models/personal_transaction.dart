import 'package:flutter/material.dart';

class PTransaction {
  String id;
  String name;
  String amount;
  int date;
  String category;
  bool isExpense;

  PTransaction(
      {this.name, this.amount, this.date, this.category, this.isExpense});

  factory PTransaction.empty() => PTransaction();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date,
      'category': category ?? 'other',
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
