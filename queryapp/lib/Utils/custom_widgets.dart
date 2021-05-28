import 'package:flutter/material.dart';

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
  AttributeButtonSelection({Key? key, required this.button_text, required this.callback}) : super(key: key);

  String button_text;
  Function callback;

  @override
  _AttributeButtonSelectionState createState() => _AttributeButtonSelectionState();
}

class _AttributeButtonSelectionState extends State<AttributeButtonSelection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextButton(
          child: Text(
            widget.button_text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onPressed: null,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
            bottomLeft: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
        ),
      ),
      flex: 1,
    );
  }
}


