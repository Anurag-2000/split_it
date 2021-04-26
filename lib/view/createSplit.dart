import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contact.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/split_transaction.dart';
import 'package:split_it/models/userData.dart';

class SplitTransaction extends StatefulWidget {
  const SplitTransaction({
    Key key,
  }) : super(key: key);
  @override
  _SplitTransactionState createState() => _SplitTransactionState();
}

class _SplitTransactionState extends State<SplitTransaction> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);
    final contactList = Provider.of<ContactList>(context);

    if (userDoc.isEmpty || contactList.contacts == null)
      return CircularProgressIndicator();

    List isCheckedList = List.filled(contactList.contacts.length, false);
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2, color: kNavy)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: kNavy)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kNavy.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            Container(
              child: TextFormField(
                controller: amountCtrl,
                decoration: InputDecoration(
                  hintText: 'Amount in \u{20B9}',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 2, color: kNavy)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: kNavy)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kNavy.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            TextFormField(
              controller: descriptionCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Notes',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 2, color: kNavy)),
                focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: kNavy)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kNavy.withOpacity(0.6),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Contacts',
                  style: TextStyle(
                      color: kNavy, fontWeight: FontWeight.w500, fontSize: 16)),
            ),
            SizedBox(
              height: 7,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 5),
                itemCount: contactList.contacts.length,
                itemBuilder: (context, index) {
                  UserContact contact = contactList.contacts[index];
                  return Container(
                    height: 27,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            activeColor: kBlue1,
                            value: isCheckedList[index],
                            onChanged: (bool value) {
                              print(value);
                              isCheckedList[index] = value;

                              setState(() {});
                              print(isCheckedList);
                            }),
                        Expanded(child: new Text(contact.name)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (isCheckedList
                          .where((element) => element == true)
                          .length ==
                      0) {
                    // toast(text: "Please select atleast 1 contact");
                    return;
                  }

                  double owedAmount = double.parse(amountCtrl.text) /
                      (isCheckedList
                              .where((element) => element == true)
                              .length +
                          1);

                  print(owedAmount);

                  List details = [];
                  List members = [];

                  contactList.contacts.forEachIndexed((contact, i) {
                    if (isCheckedList[i])
                      details.add(MemberDetails(
                              user: contact.contactId,
                              mobile: contact.mobile,
                              paid: false,
                              owes: owedAmount)
                          .toMap());
                    members.add(contact.contactId);
                  });
                  members.add(userDoc.id);

                  Map dataMap = STransaction(
                    title: titleCtrl.text,
                    description: descriptionCtrl.text,
                    amount: double.parse(amountCtrl.text),
                    details: details,
                    creator: userDoc.id,
                    members: members,
                    date: DateTime.now().millisecondsSinceEpoch,
                    settleCount: 0,
                  ).toMap();

                  DatabaseService().addTransaction(details: dataMap);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          kBlue1,
                          kBlue2,
                        ]),
                  ),
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
