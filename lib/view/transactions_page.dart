import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/split_transaction.dart';
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
      child: SafeArea(
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
                      transactions.sort((t1, t2) => t2.date.compareTo(t1.date));
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

      if (uid == userDoc.id) return null;

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

    String subTitle =
        "Created by ${getContactName(widget.sTransaction.creator)}";
    bool isCreator = widget.sTransaction.creator == userDoc.id;

    if (isCreator) {
      double owes =
          widget.sTransaction.amount / widget.sTransaction.members.length;
      print(owes);
      double owedAmount = owes *
          (widget.sTransaction.members.length -
              widget.sTransaction.settleCount -
              1);

      subTitle = 'Your are owed \u{20B9} ${owedAmount.toStringAsFixed(2)}';
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
          title: Text(
            widget.sTransaction.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
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
                ...widget.memberDetails.mapIndexed(
                  (memberDetail, index) {
                    String name = getContactName(memberDetail.user);
                    return MemberDetail(
                      transaction: widget.sTransaction,
                      name: name,
                      index: index,
                      memberDetail: memberDetail,
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

class MemberDetail extends StatelessWidget {
  const MemberDetail({
    Key key,
    @required this.name,
    @required this.memberDetail,
    @required this.index,
    @required this.transaction,
  }) : super(key: key);

  final String name;
  final MemberDetails memberDetail;
  final int index;
  final STransaction transaction;
  @override
  Widget build(BuildContext context) {
    bool isUserDetail = name == null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          Expanded(
              child: Text(isUserDetail
                  ? "You"
                  : name.isEmpty
                      ? memberDetail.mobile
                      : name)),
          memberDetail.paid
              ? Text('Settled Up!!')
              : Column(
                  children: [
                    Text('\u{20B9} ${memberDetail.owes.toStringAsFixed(2)}'),
                    isUserDetail
                        ? InkWell(
                            onTap: () {
                              print(transaction.details);
                              print(transaction.details[index]);
                              transaction.details.removeAt(index);
                              memberDetail.paid = true;
                              transaction.details
                                  .insert(index, memberDetail.toMap());
                              print(transaction.details);

                              DatabaseService().settleIt(
                                  transactionId: transaction.id,
                                  details: transaction.details);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
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
                                "Settle",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
        ],
      ),
    );
  }
}
