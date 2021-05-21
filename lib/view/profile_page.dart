import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/login/loginPage.dart';
import 'package:split_it/models/userData.dart';
import 'package:split_it/view/create_personal.dart';
import 'package:split_it/widgets/custom_chip.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  List choices = ["Male", "Female"];
  int typeIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);
    mobileCtrl.text = userDoc.doc['phoneNumber'];
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
            kBlueDark,
            kBlue1,
          ])),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: screenHeight * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kGrey1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.09,
                      ),
                      Center(
                        child: Text(
                          'Harvey Spector',
                          style: TextStyle(
                            color: kMidnight,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          'Toronto',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      CustomText(text: 'Mobile Number'),
                      CustomTextField(
                        controller: mobileCtrl,
                        hintText: "Phone Number",
                        color: kMidnight.withOpacity(0.3),
                      ),
                      CustomText(text: 'Email'),
                      CustomTextField(
                        controller: emailCtrl,
                        hintText: "Email",
                        color: kMidnight.withOpacity(0.3),
                      ),
                      CustomText(text: 'Gender'),
                      Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            height: 50,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomChip(
                                      index: index,
                                      parent: this,
                                    ),
                                  );
                                }),
                          )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.9, -0.95),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SignOutAlertDialog(),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sign Out",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.75),
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  height: screenHeight * 0.18,
                  width: screenHeight * 0.18,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    Key key,
    this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: Text(
        text,
        style: TextStyle(
          color: kMidnight,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }
}

class SignOutAlertDialog extends StatelessWidget {
  const SignOutAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      title: Text(
        "Log Out",
        style: TextStyle(fontFamily: kFont1, fontSize: 21, color: kBlue1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      content: Text(
        "Are you sure you want to logout?",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            "NO",
            style: TextStyle(fontFamily: kFont1, fontSize: 16, color: kBlue1),
          ),
        ),
        TextButton(
          onPressed: () async {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          },
          child: Text(
            "YES",
            style: TextStyle(
                fontFamily: kFont1, fontSize: 16, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
