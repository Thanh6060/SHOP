
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/circular_container.dart';

class UChoiceChip extends StatelessWidget {
  const UChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
  });

  final String text;
  final bool selected;
  final Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    bool isColor = UHelperFunctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor ? SizedBox() : Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? UColors.white : null),
        shape: isColor ? CircleBorder() : null,
        padding: isColor ? EdgeInsets.zero : null,
        labelPadding: isColor ? EdgeInsets.zero : null,
        avatar: isColor ? UCircularContainer(width: 50.0, height: 50.0, backgroundColor: UHelperFunctions.getColor(text)!) : null,
        backgroundColor: isColor ? UHelperFunctions.getColor(text) : null,
      ),
    );
  }
}
