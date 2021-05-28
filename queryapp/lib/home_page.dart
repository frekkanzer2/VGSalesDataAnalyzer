import 'package:flutter/material.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/Utils/custom_widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int centered_subpage = 0;

  void change_subpage(int newState) {
    setState(() {
      this.centered_subpage = newState;
    });
    print("Changed to " + this.centered_subpage.toString());
  }

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
        backgroundColor: custom_Black_80,
      ),
      body: Container(
        child: Column(
          children: [
            // FIRST CONTAINER
            Expanded(
              child: Container(
                color: custom_Black_70,

              ),
              flex: 3,
            ),
            SectionDivider(),
            // SECOND CONTAINER (MIDDLE)
            Expanded(
              child: CenteredSection(
                state: centered_subpage,
                hpage: this,
              ),
              flex: 8,
            ),
            SectionDivider(),
            // THIRD CONTAINER
            Expanded(
              child: Container(
                color: custom_Black_70,

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
  CenteredSection({Key? key, required this.state, required this.hpage}) : super(key: key);

  _MyHomePageState hpage;
  int state;

  @override
  _CenteredSectionState createState() => _CenteredSectionState();
}

class _CenteredSectionState extends State<CenteredSection> {

  void OnPressAttribute(String name) {
    if (name == "Rank" || name == "Year" || name == "NA_Sales" ||
        name == "EU_Sales" || name == "JA_Sales" || name == "Other_Sales" ||
        name == "Global_Sales") {
      widget.hpage.change_subpage(1);
    } else if (name == "Name" || name == "Platform" || name == "Genre" ||
        name == "Publisher") {
      widget.hpage.change_subpage(2);
    }
  }


  @override
  Widget build(BuildContext context) {

    if (widget.state > 2 || widget.state < 0) widget.state = 0;

    return Container(
      color: custom_Black_80,
      // state 0 -> all attributes
      child: (widget.state == 0) ? new Container(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // FIRST ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Rank",
                  callback: () => {
                    OnPressAttribute("Rank")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Nome",
                  callback: () => {
                    OnPressAttribute("Name")
                  },
                ),
              ],
            ),
            // SECOND ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Piattaforma",
                  callback: () => {
                    OnPressAttribute("Platform")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Anno",
                  callback: () => {
                    OnPressAttribute("Year")
                  },
                ),
              ],
            ),
            // THIRD ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Genere",
                  callback: () => {
                    OnPressAttribute("Genre")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Publisher",
                  callback: () => {
                    OnPressAttribute("Publisher")
                  },
                ),
              ],
            ),
            // FOURTH ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Vendite in N. America",
                  callback: () => {
                    OnPressAttribute("NA_Sales")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Vendite in Europa",
                  callback: () => {
                    OnPressAttribute("EU_Sales")
                  },
                ),
              ],
            ),
            // FIFTH ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Vendite in Giappone",
                  callback: () => {
                    OnPressAttribute("JA_Sales")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Vendite in altri paesi",
                  callback: () => {
                    OnPressAttribute("Other_Sales")
                  },
                ),
              ],
            ),
            // SIXTH ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Vendite in tutto il mondo",
                  callback: () => {
                    OnPressAttribute("Global_Sales")
                  },
                ),
              ],
            ),
          ],
        ),
      )
      // state 1 -> ranged values
      : (widget.state == 1) ? new Container (
        // TEMP VALUES
        width: 1000,
        color: Colors.blue,
        child: Text("INTERFACE TO IMPLEMENT"),
      )
      // state 2 -> single values
      : (widget.state == 2) ? new Container(
        // TEMP VALUES
        width: 1000,
        color: Colors.yellow,
        child: Text("INTERFACE TO IMPLEMENT"),
      )
      // unreachable case
      : Container( color: Colors.red, ),

    );

  }
}

