import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/widgets/custom_chip.dart';

class PersonalTransaction extends StatefulWidget {
  PersonalTransaction({Key key}) : super(key: key);

  @override
  PersonalTransactionState createState() => PersonalTransactionState();
}

class PersonalTransactionState extends State<PersonalTransaction> {
  int typeIndex = 0;
  List choices = ['Expense', 'Income'];
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Text('Select Type',
            style: TextStyle(
                color: kMidnight, fontSize: 18, fontWeight: FontWeight.w500)),
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
        Text('Transaction Details',
            style: TextStyle(
                color: kMidnight, fontSize: 18, fontWeight: FontWeight.w500)),
        CustomTextField(
          titleCtrl: titleCtrl,
          hintText: 'Title',
        ),
        CustomTextField(
          titleCtrl: amountCtrl,
          hintText: 'Amount',
        ),
        CustomTextField(
          titleCtrl: descriptionCtrl,
          hintText: 'Note',
          maxLines: 3,
        ),
        Spacer(),
        Spacer(),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            "SAVE",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ));
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required this.titleCtrl,
    @required this.hintText,
    this.maxLines,
  }) : super(key: key);

  final TextEditingController titleCtrl;
  final String hintText;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: TextFormField(
        controller: titleCtrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 2, color: kNavy)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kNavy)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kNavy.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
