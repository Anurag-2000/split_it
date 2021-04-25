import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/models/contactList.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final contactsList = Provider.of<ContactList>(context);

    if (contactsList.contacts == null) {
      return CircularProgressIndicator();
    }

    return Container(
      padding: EdgeInsets.all(15),
      child: Center(
          child: RefreshIndicator(
        onRefresh: () async {
          await contactsList.refresh();
        },
        child: ListView(
          children: [
            ...contactsList.contacts.map((e) => ListTile(
                  leading: Icon(Icons.person),
                  title: Text(e.name),
                  subtitle: Text(e.mobile),
                )),
          ],
        ),
      )),
    );
  }
}
