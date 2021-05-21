import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/view/contacts_page.dart';
import 'package:split_it/view/create_transaction.dart';
import 'package:split_it/view/home_page.dart';
import 'package:split_it/view/profile_page.dart';
import 'package:split_it/view/view_transaction.dart';

class Dashboard extends StatefulWidget {
  final String uid;

  Dashboard({Key key, this.uid}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState(uid: uid);
}

class _DashboardState extends State<Dashboard> {
  final String uid;

  _DashboardState({@required this.uid});

  int tabIndex = 0;
  List<Widget> tabs;
  double screenHeight;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    tabs = [
      HomePage(),
      ContactsPage(),
      CreateTransaction(),
      ViewTransaction(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: kBlue1,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CreateTransaction(),
      //       ),
      //     );
      //     return;
      //     showModalBottomSheet(
      //       isScrollControlled: true,
      //       context: context,
      //       builder: (context) => CustomBottomSheet(),
      //       elevation: 0,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(30),
      //           topRight: Radius.circular(30),
      //         ),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: kBlue1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home_outlined,
              color: kBlue1,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts_outlined,
            ),
            activeIcon: Icon(
              Icons.contacts,
              color: kBlue1,
            ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
            ),
            activeIcon: Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kBlue1,
              ),
              child: Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card_outlined,
            ),
            activeIcon: Icon(
              Icons.credit_card_outlined,
              color: kBlue1,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person_outline,
              color: kBlue1,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          print(index);
          setState(() {
            tabIndex = index;
          });
        },
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            IndexedStack(
              index: tabIndex,
              children: tabs,
            ),
          ],
        ),
      ),
    );
  }
}
