import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/transaction.dart';
import 'package:split_it/models/userData.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);

    return Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      color: kGrey1,
      child: Stack(
        children: [
          Column(
            children: [
              Text('Split Transactions',
                  style: TextStyle(
                      color: kMidnight,
                      fontWeight: FontWeight.w500,
                      fontSize: 21)),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder<List<STransaction>>(
                  stream: DatabaseService().getTransactions(userDoc.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    final transactions = snapshot.data;
                    return ListView(
                      children: [
                        ...transactions.map((sTransaction) {
                          List<MemberDetails> memberDetails =
                              sTransaction.getMemberDetails();

                          return TransactionTile(
                            memberDetails: memberDetails,
                            sTransaction: sTransaction,
                          );
                        })
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatefulWidget {
  const TransactionTile({
    Key key,
    @required this.memberDetails,
    @required this.sTransaction,
  }) : super(key: key);

  final STransaction sTransaction;
  final List<MemberDetails> memberDetails;

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);
    final contactList = Provider.of<ContactList>(context);

    String getContactName(String uid) {
      String name = "";

      if (uid == userDoc.id) return name;

      if (contactList.contacts != null && contactList.contacts.isNotEmpty) {
        try {
          name = contactList.contacts
              .where((contact) => contact.contactId == uid)
              .first
              .name;
        } catch (e) {}
      }

      return name;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kBlue1.withOpacity(0.2),
              blurRadius: 5.0,
            )
          ]),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          accentColor: kBlue1,
          unselectedWidgetColor: Colors.black,
        ),
        child: ExpansionTile(
          title: Text(widget.sTransaction.title),
          subtitle:
              Text('\u{20B9} ${widget.sTransaction.amount.toStringAsFixed(2)}'),
          childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          children: [
            Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.sTransaction.description,
                        textScaleFactor: 1.1)),
                SizedBox(
                  height: 9,
                ),
                ...widget.memberDetails.map(
                  (memberDetail) {
                    String name = getContactName(memberDetail.user);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  name.isEmpty ? memberDetail.mobile : name)),
                          memberDetail.paid
                              ? Text('Settled Up!!')
                              : Text(
                                  '\u{20B9} ${memberDetail.owes.toStringAsFixed(2)}'),
                        ],
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
