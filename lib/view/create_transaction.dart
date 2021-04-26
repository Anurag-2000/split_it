import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/view/createPersonal.dart';
import 'package:split_it/view/createSplit.dart';

class CreateTransaction extends StatefulWidget {
  const CreateTransaction({
    Key key,
  }) : super(key: key);

  @override
  _CreateTransactionState createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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
            Text('Create New Transaction',
                style: TextStyle(
                    color: kMidnight,
                    fontWeight: FontWeight.w600,
                    fontSize: 21)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kMidnight,
                borderRadius: BorderRadius.circular(5),
              ),
              // padding: EdgeInsets.all(2),
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
                        // duration: Duration(milliseconds: 500),
                        // curve: Curves.easeOut,
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
                  SplitTransaction(),
                  PersonalTransaction(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
