import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/login/otp.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
              kBlueDark,
              kBlue1,
            ])),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: kGrey1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: loading,
                  child: Opacity(
                    opacity: loading ? 0.5 : 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/login.png',
                                  height: 240,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 30,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Sign in",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 40),
                                PhoneTextField(phoneNumber: phoneNumber),
                                SizedBox(height: 30),
                                Builder(
                                  builder: (context) => TextButton(
                                      onPressed: () async {
                                        if (formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          await OTPService().sendOTP(
                                              "+91${phoneNumber.text}",
                                              context,
                                              false, stopLoading: () {
                                            setState(() {
                                              loading = false;
                                            });
                                          });
                                        } else
                                          print("Error!!!!!");
                                      },
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          backgroundColor: kBlue2,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15)),
                                      child: Container(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            "GET OTP",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                loading
                    ? Center(child: CircularProgressIndicator())
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key key,
    @required this.phoneNumber,
  }) : super(key: key);

  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      controller: phoneNumber,
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFb0cbf8).withOpacity(0.4),
        hintText: "Phone Number",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
        prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 17),
            child: RichText(
              text: TextSpan(
                text: '+91 ',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(
                      text: 'l',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 20)),
                ],
              ),
            )),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value.length != 10) {
          return "Invalid phone number";
        }
        return null;
      },
    ));
  }
}
