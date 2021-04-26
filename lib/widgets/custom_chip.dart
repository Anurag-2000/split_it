import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key key,
    @required this.parent,
    @required this.index,
  }) : super(key: key);

  final parent;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      side: parent.typeIndex == index
          ? BorderSide(color: kBlue1)
          : BorderSide(color: Colors.grey),
      label: Text(
        parent.choices[index],
        style:
            TextStyle(color: parent.typeIndex == index ? kBlue1 : Colors.grey),
      ),
      selected: parent.typeIndex == index,
      selectedColor: Colors.transparent,
      onSelected: (bool selected) {
        parent.setState(() {
          parent.typeIndex = selected ? index : 0;
        });
      },
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(color: Colors.white),
    );
  }
}
