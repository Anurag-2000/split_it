import 'package:flutter/cupertino.dart';
import '../database/database.dart';
import 'contact.dart';

class ContactList with ChangeNotifier {
  // Check for null. if null -> loading
  List<UserContact> contacts;

  ContactList() {
    refresh();
  }

  Future<void> refresh() async {
    contacts = await DatabaseService().addContacts();
    notifyListeners();
  }
}
