import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/personal_transaction.dart';
import 'package:split_it/models/userData.dart';
import 'package:intl/intl.dart';

class PersonalTransactionPage extends StatelessWidget {
  const PersonalTransactionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);

    return Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      color: kGrey1,
      child: StreamBuilder<List<PTransaction>>(
        stream: DatabaseService().getPersonalTransactions(userDoc.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final transactions = snapshot.data;
          transactions.sort((t1, t2) => t2.date.compareTo(t1.date));
          return ListView(
            children: [
              ...transactions.map((pTransaction) {
                return PersonalTransactionTile(
                  pTransaction: pTransaction,
                );
              })
            ],
          );
        },
      ),
    );
  }
}

class PersonalTransactionTile extends StatefulWidget {
  const PersonalTransactionTile({
    Key key,
    @required this.pTransaction,
  }) : super(key: key);

  final PTransaction pTransaction;

  @override
  _PersonalTransactionTileState createState() =>
      _PersonalTransactionTileState();
}

class _PersonalTransactionTileState extends State<PersonalTransactionTile> {
  @override
  Widget build(BuildContext context) {
    bool isExpense = widget.pTransaction.isExpense;
    final date = DateTime.fromMillisecondsSinceEpoch(widget.pTransaction.date);
    // final formattedDate = DateFormat.yMMMd().format(date);
    final formattedDate = DateFormat.MMMEd().format(date);

    UserData userDoc = Provider.of<UserData>(context);
    return Dismissible(
      key: ValueKey(widget.pTransaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (context) => DeleteAlertDialog(
              transactionId: widget.pTransaction.id, userId: userDoc.id),
        );
      },
      onDismissed: (direction) {
        setState(() {});
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: kBlue1.withOpacity(0.2),
              blurRadius: 5.0,
            )
          ],
        ),
        child: Align(
          alignment: Alignment(0.9, 0),
          child: Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: kBlue1.withOpacity(0.2),
              blurRadius: 5.0,
            )
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            accentColor: kBlue1,
            unselectedWidgetColor: Colors.black,
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                color: kBlue1.withOpacity(0.8),
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.pTransaction.title}',
                      style: TextStyle(
                        color: kBlue1,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('$formattedDate',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kBlue1,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    ((isExpense ? '-' : '+') +
                        ' \u{20B9}${widget.pTransaction.amount.toStringAsFixed(2)}'),
                    style: TextStyle(
                        color: isExpense ? kRed : kGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key key,
    this.name,
    this.date,
    this.price,
  }) : super(key: key);
  final String name;
  final String date;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              // offset: Offset(3, 5),
              blurRadius: 9,
              color: Colors.grey.withOpacity(0.4)),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.monetization_on_outlined,
            color: kBlue1,
            size: 33,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: kBlue1,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(date,
                    style: TextStyle(
                      color: kBlue1,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ('- \u{20B9}$price'),
                style: TextStyle(
                    color: kRed, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DeleteAlertDialog extends StatelessWidget {
  final String transactionId;
  final String userId;
  const DeleteAlertDialog(
      {Key key, @required this.transactionId, @required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      title: Text(
        "Confirm Deletion",
        style: TextStyle(fontFamily: kFont1, fontSize: 21, color: kBlue1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      content: Text(
        "Deleted transaction cannot be retrived!!",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontFamily: kFont1, fontSize: 16, color: kBlue1),
          ),
        ),
        TextButton(
          onPressed: () async {
            await DatabaseService().deletePersonalTransaction(
                uid: userId, transactionId: transactionId);
            Navigator.pop(context, true);
          },
          child: Text(
            "Delete",
            style: TextStyle(
                fontFamily: kFont1, fontSize: 16, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
