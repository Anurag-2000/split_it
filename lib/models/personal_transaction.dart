import 'package:flutter/material.dart';

class PTransaction {
  String id;
  String title;
  String description;
  double amount;
  int date;
  String category;
  bool isExpense;

  PTransaction(
      {this.id,
      this.title,
      this.amount,
      this.date,
      this.category,
      this.isExpense,
      this.description});

  factory PTransaction.empty() => PTransaction();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'category': category ?? 'other',
      'description': description,
      'isExpense': isExpense,
    };
  }

  PTransaction.fromMapObject(
      {@required String id, @required Map<String, dynamic> data}) {
    this.id = id;
    this.title = data['title'];
    this.description = data['description'];
    this.amount = data['amount'];
    this.date = data['date'];
    this.isExpense = data['isExpense'];
  }
}
