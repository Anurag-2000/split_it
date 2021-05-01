import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/view/personal_transaction_page.dart';
import 'package:split_it/view/split_transactions_page.dart';

class ViewTransaction extends StatefulWidget {
  const ViewTransaction({
    Key key,
  }) : super(key: key);

  @override
  _ViewTransactionState createState() => _ViewTransactionState();
}

class _ViewTransactionState extends State<ViewTransaction> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: kGrey1,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('View Transactions',
                style: TextStyle(
                    color: kMidnight,
                    fontWeight: FontWeight.w600,
                    fontSize: 21)),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kMidnight,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        pageIndex = 0;
                      });
                      pageController.jumpToPage(
                        0,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                      decoration: BoxDecoration(
                        color: pageIndex == 0 ? kBlue1 : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('Shared',
                          style: TextStyle(
                              color:
                                  pageIndex == 0 ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        pageIndex = 1;
                      });
                      print(pageIndex);
                      pageController.jumpToPage(
                        1,
                        // duration: Duration(milliseconds: 100),
                        // curve: Curves.easeIn,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                      decoration: BoxDecoration(
                        color: pageIndex != 0 ? kBlue1 : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('Personal',
                          style: TextStyle(
                              color:
                                  pageIndex != 0 ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SplitTransactionPage(),
                  PersonalTransactionPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
