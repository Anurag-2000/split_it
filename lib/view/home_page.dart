import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/personal_transaction.dart';
import 'package:split_it/models/split_transaction.dart';
import 'package:split_it/models/userData.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TransactionData {
  TransactionData(this.year, this.sales);
  final double year;
  final double sales;
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TransactionData> chartData = [
    TransactionData(21, 350),
    TransactionData(22, 900),
    TransactionData(23, 580),
    TransactionData(24, 280),
    TransactionData(25, 400),
    TransactionData(26, 100),
    TransactionData(27, 1000),
    TransactionData(28, 1200),
    TransactionData(29, 1400),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: kBlueDark,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
            kBlueDark,
            kBlue1,
          ])),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Split It',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.white),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/gabriel.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 9,
            ),
            Text(
              "\"It's what you do in the dark,\nthat puts you in light\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            Spacer(),
            Recents(),
            true
                ? SizedBox()
                // ignore: dead_code
                : Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    height: 200,
                    color: kMidnight,
                    child: SfCartesianChart(series: <ChartSeries>[
                      ColumnSeries<TransactionData, double>(
                          xAxisName: 'Days',
                          yAxisName: 'Expenditure',
                          name: "Expense",
                          color: kBlue1,
                          dataSource: chartData,
                          trackColor: Colors.transparent,
                          trackBorderColor: Colors.transparent,
                          // ignore: missing_return
                          pointColorMapper: (_, __) {
                            // return Colors.yellow;
                          },
                          borderColor: Colors.transparent,
                          xValueMapper: (TransactionData sales, _) =>
                              sales.year.round().toDouble(),
                          yValueMapper: (TransactionData sales, _) =>
                              sales.sales)
                    ]),
                  ),
          ],
        ),
      ),
    );
  }
}

class Recents extends StatelessWidget {
  const Recents({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.7,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: kGrey1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  color: kBlueDark2,
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Personal',
                  style: TextStyle(
                    color: kBlue1,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "See all",
                        style: TextStyle(
                          color: kBlue1,
                        ),
                      ),
                      Icon(Icons.navigate_next, color: kBlue1),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: screenHeight * 0.33,
              child: StreamBuilder<List<PTransaction>>(
                stream: DatabaseService().getPersonalTransactions(userDoc.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final transactions = snapshot.data;
                  transactions.sort((t1, t2) => t2.date.compareTo(t1.date));
                  if (transactions.length > 3)
                    transactions.removeRange(2, transactions.length);
                  return ListView(
                    children: [
                      ...transactions.map((pTransaction) {
                        return TransactionTile(
                          pTransaction: pTransaction,
                        );
                      })
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Shared',
                  style: TextStyle(
                    color: kBlue1,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "See all",
                        style: TextStyle(
                          color: kBlue1,
                        ),
                      ),
                      Icon(Icons.navigate_next, color: kBlue1),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: screenHeight * 0.33,
              child: StreamBuilder<List<STransaction>>(
                stream: DatabaseService().getTransactions(userDoc.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final transactions = snapshot.data;
                  transactions.sort((t1, t2) => t2.date.compareTo(t1.date));
                  if (transactions.length > 3)
                    transactions.removeRange(2, transactions.length);
                  return ListView(
                    children: [
                      ...transactions.map((sTransaction) {
                        List<MemberDetails> memberDetails =
                            sTransaction.getMemberDetails();
                        return SharedTransactionTile(
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
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({Key key, this.pTransaction}) : super(key: key);

  final PTransaction pTransaction;

  @override
  Widget build(BuildContext context) {
    bool isExpense = pTransaction.isExpense;
    final date = DateTime.fromMillisecondsSinceEpoch(pTransaction.date);
    final formattedDate = DateFormat.MMMd().format(date);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/money.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pTransaction.title}',
                    style: TextStyle(
                      color: kBlue1,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('${pTransaction.description}',
                      maxLines: 1,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ((isExpense ? '-' : '+') +
                      ' \u{20B9}${pTransaction.amount.toStringAsFixed(2)}'),
                  style: TextStyle(
                      color: isExpense ? kRed : kGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                SizedBox(height: 5),
                Text('$formattedDate',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kBlue1,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SharedTransactionTile extends StatelessWidget {
  const SharedTransactionTile({Key key, this.sTransaction, this.memberDetails})
      : super(key: key);

  final STransaction sTransaction;
  final List<MemberDetails> memberDetails;
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

    final date = DateTime.fromMillisecondsSinceEpoch(sTransaction.date);
    final formattedDate = DateFormat.MMMd().format(date);

    double owes = sTransaction.amount / sTransaction.members.length;

    String subTitle =
        "You owe ${getContactName(sTransaction.creator)} \u{20B9} ${owes.toStringAsFixed(2)}";
    bool isCreator = sTransaction.creator == userDoc.id;

    if (isCreator) {
      double owedAmount =
          owes * (sTransaction.members.length - sTransaction.settleCount - 1);

      subTitle = 'You are owed \u{20B9} ${owedAmount.toStringAsFixed(2)}';
    } else {
      List<MemberDetails> memberDetails = sTransaction.getMemberDetails();
      memberDetails.forEach((member) {
        if (member.user == userDoc.id) if (member.paid)
          subTitle = "Transaction settled!";
      });
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/money.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${sTransaction.title}',
                    style: TextStyle(
                      color: kBlue1,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('$subTitle',
                      maxLines: 1,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 5),
                Text('$formattedDate',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kBlue1,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
