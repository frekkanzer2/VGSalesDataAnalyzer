import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:queryapp/Beans/operation_container.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/Utils/custom_widgets.dart';
import 'package:queryapp/View/home_page.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class SortPage extends StatefulWidget {
  @override
  _SortPageState createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {

  double screen_height = 0;
  String chosen_attribute = "";

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screen_height,
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "VG Sales Analysis - Sort",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: custom_Black_80,
              ),
              // FIRST CONTAINER
              Expanded(
                child: Container(
                  color: Colors.red,
                  // -----------------------------SPAZIO PER I FILTRI------------------------

                ),
                flex: 4,
              ),
              SectionDivider(),
              // SECOND CONTAINER
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                  color: custom_Black_80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(11),
                            child: DropDownFormField(
                              titleText: "",
                              hintText: "Scegliere un attributo",
                              value: chosen_attribute,
                              onSaved: (value) {
                                setState(() {
                                  chosen_attribute = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  chosen_attribute = value;
                                });
                              },
                              dataSource: [
                                {
                                  "display" : "Rank",
                                  "value" : "Rank",
                                },
                                {
                                  "display" : "Name",
                                  "value" : "Name",
                                },
                                {
                                  "display" : "Platform",
                                  "value" : "Platform",
                                },
                                {
                                  "display" : "Year",
                                  "value" : "Year",
                                },
                                {
                                  "display" : "Genre",
                                  "value" : "Genre",
                                },
                                {
                                  "display" : "Publisher",
                                  "value" : "Publisher",
                                },
                                {
                                  "display" : "NA_Sales",
                                  "value" : "NA_Sales",
                                },
                                {
                                  "display" : "EU_Sales",
                                  "value" : "EU_Sales",
                                },
                                {
                                  "display" : "JP_Sales",
                                  "value" : "JP_Sales",
                                },
                                {
                                  "display" : "Other_Sales",
                                  "value" : "Other_Sales",
                                },
                                {
                                  "display" : "Global_Sales",
                                  "value" : "Global_Sales",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          AttributeButtonSelection(
                              button_text: "Asc.",
                              hasBorders: true,
                              callback: () => {
                                // -----------------------------------------------

                              }
                          ),
                          AttributeButtonSelection(
                              button_text: "Disc.",
                              hasBorders: true,
                              callback: () => {
                                // -----------------------------------------------

                              }
                          )
                        ],
                      )
                    ],
                  ),
                ),
                flex: 10,
              ),
              SectionDivider(),
              // THIRD CONTAINER
              Expanded(
                child: Container(
                  color: custom_Black_70,
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      AttributeButtonSelection(
                        button_text: "Indietro",
                        hasBorders: false,
                        callback: () {
                          OperationContainer oc = new OperationContainer();
                          oc.reset();
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: MyHomePage(),
                            ),
                            ModalRoute.withName("/Home"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

}