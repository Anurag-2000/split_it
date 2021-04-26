import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: kGrey1,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.menu), onPressed: () {}),
                Text('Split It',
                    style: TextStyle(
                        color: Color(0xff242424),
                        fontWeight: FontWeight.bold,
                        fontSize: 21)),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Text('Your Groups',
                  style: TextStyle(
                      color: kMidnight,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
            ),
            Flexible(
              child: Container(
                height: 50,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    GroupCard(
                      color: kGreen,
                      text: "Flat Mates",
                      value: 12000.00,
                    ),
                    GroupCard(
                      color: kGreen,
                      text: "Movie",
                      value: 12000.00,
                    ),
                    GroupCard(
                      color: kGreen,
                      text: "Trip",
                      value: 12000.00,
                    ),
                    GroupCard(
                      color: kGreen,
                      text: "Metro",
                      value: 12000.00,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Text('Overview Report',
                  style: TextStyle(
                      color: kMidnight,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(
                  color: kGreen,
                  image: "assets/images/increment.png",
                  text: "Income",
                  value: 12000.00,
                ),
                StatCard(
                  color: kRed,
                  image: "assets/images/decrement.png",
                  text: "Expense",
                  value: 7000.00,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Transactions',
                    style: TextStyle(
                      color: kMidnight,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(primary: kBlue1),
                      child: Row(
                        children: [Text("See all"), Icon(Icons.navigate_next)],
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 400,
                child: ListView(
                  children: [
                    TransactionCard(
                        name: "Books", date: "Sat, 15 Mar 2021", price: "750"),
                    TransactionCard(
                        name: "Movie", date: "Fri, 11 Mar 2021", price: "450"),
                    TransactionCard(
                        name: "Food", date: "Tue, 28 Feb 2021", price: "900"),
                    TransactionCard(
                        name: "Outing",
                        date: "Sat, 15 Mar 2021",
                        price: "1200"),
                    TransactionCard(
                        name: "Books", date: "Sat, 15 Mar 2021", price: "750"),
                  ],
                ),
              ),
            ),
          ],
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
            color: kIndigo,
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

class StatCard extends StatelessWidget {
  const StatCard({
    Key key,
    this.color,
    this.image,
    this.text,
    this.value,
  }) : super(key: key);
  final Color color;
  final String image;
  final String text;
  final double value;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.09,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
              offset: Offset(3, 5),
              blurRadius: 5,
              color: color.withOpacity(0.2)),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                ('\u{20B9}${value.toStringAsFixed(2)}'),
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          SizedBox(
            width: screenWidth * 0.03,
          ),
          Container(
            width: 30,
            child: Image.asset(
              image,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key key,
    this.color,
    this.text,
    this.value,
  }) : super(key: key);
  final Color color;
  final String text;
  final double value;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.3,
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            kPurpleLight,
            kIndigo,
          ],
        ),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          // BoxShadow(
          //   offset: Offset(3, 5),
          //   spreadRadius: 1,
          //   blurRadius: 5,
          // ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }
}
