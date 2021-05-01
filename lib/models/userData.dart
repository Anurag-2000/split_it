import 'package:split_it/models/personal_transaction.dart';

class UserData {
  final Map<String, dynamic> doc;
  final String id;
  final List<PTransaction> listTransactions;

  UserData({
    this.doc,
    this.id,
    this.listTransactions,
  });

  factory UserData.empty() => UserData();

  bool get isEmpty => (doc == null && id == null);
}
