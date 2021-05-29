import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:queryapp/Utils/custom_colors.dart';

class SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      thickness: 2,
      color: Colors.black,
    );
  }
}

class AttributeButtonSelection extends StatefulWidget {
  AttributeButtonSelection({Key? key, required this.button_text,
    required this.callback, required this.hasBorders}) : super(key: key);

  String button_text = "";
  VoidCallback callback;
  bool hasBorders = true;

  @override
  _AttributeButtonSelectionState createState() => _AttributeButtonSelectionState();
}

class _AttributeButtonSelectionState extends State<AttributeButtonSelection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextButton(
          child: AutoSizeText(
            widget.button_text,
            maxLines: 1,
            overflow: TextOverflow.fade,
            minFontSize: 14,
            style: TextStyle(
              color: custom_White_70,
              fontSize: 18,
            ),
          ),
          onPressed: widget.callback,
        ),
        decoration: BoxDecoration(
          color: custom_Black_70,
          border: (widget.hasBorders) ? Border.all(
            color: custom_Black_100,
            width: 2,
          ) : null,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
            bottomLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(8.0),
          ),
        ),
      ),
      flex: 1,
    );
  }
}


