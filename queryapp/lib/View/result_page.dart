import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:queryapp/Beans/operation_container.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/Utils/custom_widgets.dart';
import 'package:queryapp/Utils/database_utils.dart';
import 'package:queryapp/View/home_page.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  bool hasLoaded = false;
  bool canQuery = false;
  List<Map<String, dynamic>> obtainedResults = new List.generate(0, (index) => {});

  /*
  * queryResult values
  * 0 - Empty query
  * 1 - Full query
  * */
  int queryResult = -1;

  @override
  void initState() {
    super.initState();
    executeQuery();
  }

  void executeQuery() async {
    OperationContainer oc = new OperationContainer();
    if (!oc.aggregation_isEnabled()) {
      String queryString = oc.getQuery();
      if (queryString == "{}") queryResult = 0;
      else queryResult = 1;
      if (queryResult == 0) {
        hasLoaded = true;
        canQuery = false;
      }
      if (queryResult == 1) {
        // can execute on database
        obtainedResults = await DatabaseUtils.executeQuery();
        print(obtainedResults);
        setState(() {
          canQuery = true;
          hasLoaded = true;
        });
      }
    } else {
      // Aggregation enabled
      Map _m = await DatabaseUtils.executeAggregate();
      print(_m);
      List<dynamic> dynList = _m["cursor"]["firstBatch"];
      List<Map<String, dynamic>> mapsList = dynList.cast<Map<String, dynamic>>();
      obtainedResults = mapsList;
      setState(() {
        canQuery = true;
        hasLoaded = true;
      });
    }
  }

  double screen_height = 0;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                  child: (!hasLoaded) ?
                  // DATA NOT LOADED CASE
                  Container(
                      color: custom_Black_70,
                      child: Center(
                        child: AutoSizeText(
                            "Caricamento...",
                            style: TextStyle(
                              fontSize: 22,
                              color: custom_White_70,
                            )
                        ),
                      )
                  )
                  // DATA LOADED CASE
                      : Container(
                    color: custom_Black_70,
                    child: (canQuery && obtainedResults.length == 0) ?
                        Padding(
                          padding: const EdgeInsets.all(58),
                          child: Center(
                            child: AutoSizeText(
                              "Non sono stati trovati dati inerenti alla ricerca effettuata",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: custom_White_70,
                              ),
                            )
                          ),
                        )
                        : (!canQuery) ?
                        Padding(
                          padding: const EdgeInsets.all(58),
                          child: Center(
                              child: AutoSizeText(
                                "Non è stato selezionato alcun criterio per la ricerca",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: custom_White_70,
                                ),
                              )
                          ),
                        ) :
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: obtainedResults.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    showAlertDialog(context, obtainedResults[index]);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.only(left: 8, right: 10),
                                          decoration: BoxDecoration(
                                            color: custom_White_70,
                                            border: Border.all(
                                              color: custom_Black_100,
                                              width: 2,
                                            ),
                                            borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(8.0),
                                              topRight: const Radius.circular(8.0),
                                              bottomLeft: const Radius.circular(8.0),
                                              bottomRight: const Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  obtainedResults[index]["Name"],
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                  minFontSize: 14,
                                                  style: TextStyle(
                                                    color: custom_Black_100,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    AutoSizeText(
                                                      obtainedResults[index]["Platform"],
                                                      overflow: TextOverflow.clip,
                                                      maxLines: 1,
                                                      minFontSize: 10,
                                                      style: TextStyle(
                                                        color: custom_Black_100,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Expanded(child: Container()),
                                                    Container(
                                                      child: AutoSizeText(
                                                        obtainedResults[index]["Publisher"],
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        minFontSize: 10,
                                                        style: TextStyle(
                                                          color: custom_Black_100,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ),
                  ),
                  flex: (obtainedResults.length > 0) ? 22 : 24,
                ),
                (obtainedResults.length > 0) ?
                    // Display number of results
                Expanded(
                  child: Container(
                    color: custom_Black_80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SectionDivider(),
                        Expanded(child: Container(), flex: 1,),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 16, bottom: 1),
                              child: AutoSizeText(
                                obtainedResults.length.toString() + " risultati ottenuti",
                                maxLines: 1,
                                minFontSize: 14,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: custom_White_70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container(), flex: 1,),
                      ],
                    ),
                  ),
                  flex: 1,
                ) : Container(), // Empty container to display nothing
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
                            if (hasLoaded) {
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
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (!hasLoaded) return false;
    else return true;
  }

  showAlertDialog(BuildContext context, Map<String, dynamic> item) {

    // show the dialog
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 24,
        insetPadding: EdgeInsets.fromLTRB(30, 150, 30, 150),
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: custom_Black_70,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: AutoSizeText(
                      item["Name"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 16,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: SectionDivider(),
                ),
                AutoSizeText(
                  "Rank: " + item["Rank"].toString(),
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Pubblicato nel " + item["Year"].toString(),
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Piattaforma: " + item["Platform"].toString(),
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Publisher: " + item["Publisher"].toString(),
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Genere: " + item["Genre"].toString(),
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Vendite in Nord America: " + item["NA_Sales"].toString() + " MLN",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Vendite in Europa: " + item["EU_Sales"].toString() + " MLN",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Vendite in Giappone: " + item["JP_Sales"].toString() + " MLN",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Vendite in altri paesi: " + item["Other_Sales"].toString() + " MLN",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
                AutoSizeText(
                  "Vendite nel mondo: " + item["Global_Sales"].toString() + " MLN",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );

  }

}
