import 'package:flutter/material.dart';

class STransaction {
  String id;
  String title;
  double amount;
  int date;
  List members;
  String description;
  List details;
  String creator;

  STransaction({
    this.id,
    this.title,
    this.amount,
    this.date,
    this.members,
    this.description,
    this.details,
    this.creator,
  });

  factory STransaction.empty() => STransaction();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'members': members,
      'description': description,
      'creator': creator,
      'details': details
    };
  }

  STransaction.fromMapObject(
      {@required String id, @required Map<String, dynamic> data}) {
    this.id = id;
    this.title = data['title'] ?? "";
    this.amount = data['amount'] ?? 0.0;
    this.date = data['date'] ?? "";
    this.members = data['members'] ?? [];
    this.description = data['description'] ?? "";
    this.creator = data['creator'] ?? "";
    this.details = data['details'] ?? [];
  }

  List<MemberDetails> getMemberDetails() {
    List<MemberDetails> memberDetails = List.from(
      this.details.map(
            (detail) => MemberDetails(
                user: detail['user'],
                owes: double.parse(detail['owes'].toString()),
                paid: detail['paid'],
                mobile: detail['mobile']),
          ),
    );
    return memberDetails;
  }
}

class MemberDetails {
  String user;
  String mobile;
  double owes;
  bool paid;

  MemberDetails({
    this.user,
    this.owes,
    this.paid,
    this.mobile,
  });

  factory MemberDetails.empty() => MemberDetails();

  Map<String, dynamic> toMap() {
    return {'user': user, 'owes': owes, 'paid': paid, 'mobile': mobile};
  }

  MemberDetails.fromMapObject(
      {@required String id, @required Map<String, dynamic> data}) {
    this.user = user;
    this.owes = data['owes'] ?? "";
    this.paid = data['paid'] ?? false;
    this.mobile = data['mobile'];
  }
}
