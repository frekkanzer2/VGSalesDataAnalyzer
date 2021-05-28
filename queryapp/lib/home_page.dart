import 'package:flutter/material.dart';
import 'package:queryapp/Utils/custom_widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VG Sales Analysis",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(

              ),
              flex: 3,
            ),
            SectionDivider(),
            // SECOND CONTAINER (MIDDLE)
            Expanded(
              child: CenteredSection(
                state: 0,
              ),
              flex: 8,
            ),
            SectionDivider(),
            Expanded(
              child: Container(

              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class CenteredSection extends StatefulWidget {
  CenteredSection({Key? key, required this.state}) : super(key: key);

  int state;

  @override
  _CenteredSectionState createState() => _CenteredSectionState();
}

class _CenteredSectionState extends State<CenteredSection> {
  @override
  Widget build(BuildContext context) {

    if (widget.state > 2 || widget.state < 0) widget.state = 0;

    return Container(

      // state 0 -> all attributes
      child: (widget.state == 0) ? new Container(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Rank",
                  callback: () => {
                    // TEMP
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Name",
                  callback: () => {
                    // TEMP
                  },
                ),
              ],
            ),
            Row(

            ),
            Row(

            ),
            Row(

            ),
            Row(

            ),
            Row(

            ),
          ],
        ),
      )
      // state 1 -> ranged values
      : (widget.state == 1) ? new Container (
        color: Colors.blue,
      )
      // state 2 -> single values
      : (widget.state == 2) ? new Container(
        color: Colors.yellow,
      )
      // unreachable case
      : Container( color: Colors.red, ),

    );

  }
}

