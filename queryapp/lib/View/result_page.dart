import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:queryapp/Beans/operation_container.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/Utils/custom_widgets.dart';
import 'package:queryapp/View/home_page.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  double screen_height = 0;

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
                  "VG Sales Analysis - Results",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: custom_Black_80,
              ),
              // FIRST CONTAINER
              Expanded(
                child: Container(color: Colors.red,),
                flex: 10,
              ),
              SectionDivider(),
              // SECOND CONTAINER
              Expanded(
                child: Container(
                  color: custom_Black_70,
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      AttributeButtonSelection(
                        button_text: "Nuova ricerca",
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
