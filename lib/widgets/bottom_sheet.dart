import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contact.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/split_transaction.dart';
import 'package:split_it/models/userData.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController(text: "0.00");

  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);

    final contactList = Provider.of<ContactList>(context);
    final isCheckedList = List.filled(contactList.contacts.length, false);

    double screenHeight = MediaQuery.of(context).size.height;

    double screenWidth = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: screenHeight * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: kGrey1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              thickness: 5,
              color: kMidnight.withOpacity(0.2),
              indent: screenWidth * 0.3,
              endIndent: screenWidth * 0.3,
            ),
            Text('Create New Transaction',
                style: TextStyle(
                    color: kMidnight,
                    fontWeight: FontWeight.w500,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
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
              height: 5,
            ),
            Container(
              height: 45,
              child: TextFormField(
                controller: descriptionCtrl,
                decoration: InputDecoration(
                  hintText: 'Description',
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
              height: 5,
            ),
            Container(
              height: 45,
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
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Contacts',
                  style: TextStyle(
                      color: kNavy, fontWeight: FontWeight.w500, fontSize: 15)),
            ),
            Flexible(
              // fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: contactList.contacts.length,
                itemBuilder: (context, index) {
                  UserContact contact = contactList.contacts[index];
                  return Container(
                    height: 27,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: new Text(contact.name)),
                        Checkbox(
                            value: isCheckedList[index],
                            onChanged: (bool value) {
                              print(value);
                              isCheckedList[index] = value;

                              setState(() {});
                              print(isCheckedList);
                            })
                      ],
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                if (isCheckedList.where((element) => element == true).length ==
                    0) {
                  // toast(text: "Please select atleast 1 contact");
                  return;
                }

                double owedAmount = double.parse(amountCtrl.text) /
                    (isCheckedList.where((element) => element == true).length +
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
                        date: DateTime.now().millisecondsSinceEpoch)
                    .toMap();

                DatabaseService().addTransaction(details: dataMap);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 0, right: 50, left: 50, top: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        kBlue1,
                        kBlue2,
                      ]),
                ),
                width: screenWidth,
                height: 40,
                child: Text(
                  "Create Transaction",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

void toast({String text}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
// SearchableDropdown.single(
//                 hint: DropdownMenuItem<String>(
//                   child: Text(
//                     'Select Contacts',
//                     style: TextStyle(color: Colors.black45),
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 // key: ValueKey('College Dropdown 1'),
//                 displayClearIcon: false,
//                 isExpanded: false,
//                 icon: Icon(Icons.add, color: kMidnight),
//                 // value: collegPref1,
//                 items: contactList.contacts
//                     .map<DropdownMenuItem<UserContact>>((UserContact value) {
//                   return DropdownMenuItem<UserContact>(
//                     value: value,
//                     child: Center(
//                         child: Text(
//                       value.name,
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     )),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   // setState(() {
//                   //   collegPref1 = value;
//                   // });
//                 }
