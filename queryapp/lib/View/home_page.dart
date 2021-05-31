import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:queryapp/Beans/operation_container.dart';
import 'package:queryapp/EditedPlugins/dropdown_form_field.dart';
import 'package:queryapp/Utils/custom_colors.dart';
import 'package:queryapp/Utils/custom_widgets.dart';
import 'package:queryapp/View/result_page.dart';
import 'package:queryapp/View/sort_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double screen_height = 0;

  OperationContainer oc = new OperationContainer();
  int centered_subpage = 0;

  void change_subpage(int newState) {
    setState(() {
      this.centered_subpage = newState;
    });
  }

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
                  "VG Sales Analysis",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: custom_Black_80,
              ),
              // FIRST CONTAINER
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  color: custom_Black_70,
                  child: (oc.getOperations().length > 0) ?
                    new ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: oc.getOperations().length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
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
                                height: 36,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    oc.getOperation(index),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: custom_Black_100,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              flex: 9,
                            ),
                            Expanded(
                              child: Container(
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
                                height: 36,
                                child: TextButton(
                                  onPressed: () {
                                    oc.removeOperation(index);
                                    change_subpage(0);
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: custom_Black_100,
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                          ]
                        );
                      }
                    ) :
                    AutoSizeText(
                      "Non è stato registrato alcun criterio",
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 16,
                      ),
                    ),
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
              (centered_subpage == 0 || centered_subpage == 3) ?
              Expanded(
                child: Container(
                  color: custom_Black_70,
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [

                      (centered_subpage == 3) ?
                      AttributeButtonSelection(
                        button_text: "Indietro",
                        hasBorders: false,
                        callback: () {
                          change_subpage(0);
                        },
                      ) :

                      AttributeButtonSelection(
                        button_text: "Avanzate",
                        hasBorders: false,
                        callback: () {
                          change_subpage(3);
                        },
                      ),

                      AttributeButtonSelection(
                        button_text: "Esegui",
                        hasBorders: false,
                        callback: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ResultsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class CenteredSection extends StatefulWidget {
  CenteredSection({Key? key, required this.state, required this.hpage}) : super(key: key);

  _MyHomePageState hpage;
  int state;
  static String selectedAttribute = "";

  @override
  _CenteredSectionState createState() => _CenteredSectionState();
}

class _CenteredSectionState extends State<CenteredSection> {

  void OnPressAttribute(String name) {
    inputHandler.text = ""; // Resetting input field
    inputRangeStartHandler.text = ""; // Resetting input field
    inputRangeEndHandler.text = ""; // Resetting input field
    CenteredSection.selectedAttribute = name;
    if (name == "Rank" || name == "Year" || name == "NA_Sales" ||
        name == "EU_Sales" || name == "JA_Sales" || name == "Other_Sales" ||
        name == "Global_Sales") {
      widget.hpage.change_subpage(1);
    } else if (name == "Name" || name == "Platform" || name == "Genre" ||
        name == "Publisher") {
      widget.hpage.change_subpage(2);
    } else if (name == "Avanzate"){
      widget.hpage.change_subpage(3);
    }
  }

  String getLabelFromAttributeName(String name) {
    if (name == "Rank") return "Rank";
    if (name == "Year") return "Anno";
    if (name == "NA_Sales") return "Vendite in Nord America";
    if (name == "EU_Sales") return "Vendite in Europa";
    if (name == "JA_Sales") return "Vendite in Giappone";
    if (name == "Other_Sales") return "Vendite in altri paesi";
    if (name == "Global_Sales") return "Vendite nel mondo";
    if (name == "Name") return "Nome";
    if (name == "Platform") return "Piattaforma";
    if (name == "Genre") return "Genere";
    if (name == "Publisher") return "Publisher";
    return "";
  }

  TextEditingController inputHandler = new TextEditingController();
  TextEditingController inputRangeStartHandler = new TextEditingController();
  TextEditingController inputRangeEndHandler = new TextEditingController();
  TextEditingController inputLimitHandler = new TextEditingController();
  TextEditingController inputSkipHandler = new TextEditingController();
  String choiseHandler = "";

  @override
  Widget build(BuildContext context) {

    if (widget.state > 5 || widget.state < 0) widget.state = 0;

    return Container(
      color: custom_Black_80,

      // state 0 -> all attributes

      child: (widget.state == 0) ? new Container(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // FIRST ROW
            Row(
              children: [
                AttributeButtonSelection(
                  button_text: "Rank",
                  hasBorders: true,
                  callback: () => {
                    OnPressAttribute("Rank")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Nome",
                  hasBorders: true,
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
                  hasBorders: true,
                  callback: () => {
                    OnPressAttribute("Platform")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Anno",
                  hasBorders: true,
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
                  hasBorders: true,
                  callback: () => {
                    OnPressAttribute("Genre")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Publisher",
                  hasBorders: true,
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
                  hasBorders: true,
                  callback: () => {
                    OnPressAttribute("NA_Sales")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Vendite in Europa",
                  hasBorders: true,
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
                  hasBorders: true,
                  callback: () => {
                    OnPressAttribute("JA_Sales")
                  },
                ),
                Container(
                  width: 10,
                ),
                AttributeButtonSelection(
                  button_text: "Vendite in altri paesi",
                  hasBorders: true,
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
                  hasBorders: true,
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

      : (widget.state == 1) ? new Container(
        padding: EdgeInsets.fromLTRB(18, 20, 18, 20),
        child: Column(
          children: [
            AutoSizeText(
              getLabelFromAttributeName(CenteredSection.selectedAttribute),
              minFontSize: 14,
              style: TextStyle(
                color: custom_White_70,
                fontSize: 32,
              ),
            ),
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(bottom: 14),
              child: TextFormField(
                controller: inputRangeStartHandler,
                style: TextStyle(
                  color: custom_White_70,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Inserisci il primo valore del range",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_Black_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(bottom: 28),
              child: TextFormField(
                controller: inputRangeEndHandler,
                style: TextStyle(
                  color: custom_White_70,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Inserisci il secondo valore del range",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_Black_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextButton(
                        child: AutoSizeText(
                          "Come funziona?",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          minFontSize: 14,
                          style: TextStyle(
                            color: custom_White_70,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          showAlertDialog(context);
                        }
                      ),
                      decoration: BoxDecoration(
                        color: custom_Black_70,
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
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 140,
                  child: TextButton(
                    child: AutoSizeText(
                      "Annulla",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      minFontSize: 14,
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => {
                      widget.hpage.change_subpage(0), // Go back
                    },
                  ),
                  decoration: BoxDecoration(
                    color: custom_Black_70,
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
                ),
                Container(
                  width: 140,
                  child: TextButton(
                    child: AutoSizeText(
                      "Conferma",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      minFontSize: 14,
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      String firstInputSearch = inputRangeStartHandler.text;
                      String secondInputSearch = inputRangeEndHandler.text;
                      if ((firstInputSearch == null || firstInputSearch.isEmpty || firstInputSearch == "" || firstInputSearch == " ") &&
                          (secondInputSearch == null || secondInputSearch.isEmpty || secondInputSearch == "" || secondInputSearch == " ")) {
                        widget.hpage.change_subpage(0);
                      } else {
                        OperationContainer oc = new OperationContainer();
                        bool isEmptyFirst = false;
                        bool isEmptySecond = false;
                        if ((firstInputSearch == null || firstInputSearch.isEmpty ||
                            firstInputSearch == "" || firstInputSearch == " ")) {
                          isEmptyFirst = true;
                        }
                        if ((secondInputSearch == null || secondInputSearch.isEmpty ||
                            secondInputSearch == "" || secondInputSearch == " ")) {
                          isEmptySecond = true;
                        }
                        if (!isEmptyFirst && !isEmptySecond)
                          oc.addOperationRange(CenteredSection.selectedAttribute, firstInputSearch, secondInputSearch);
                        else if (!isEmptyFirst)
                          oc.addOperationRange(CenteredSection.selectedAttribute, firstInputSearch, "");
                        else if (!isEmptySecond)
                          oc.addOperationRange(CenteredSection.selectedAttribute, "", secondInputSearch);
                        widget.hpage.change_subpage(0);
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                    color: custom_Black_70,
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
                ),
              ],
            )
          ],
        ),
      )

      // state 2 -> single values

      : (widget.state == 2) ? new Container(
        padding: EdgeInsets.fromLTRB(18, 20, 18, 20),
        child: Column(
          children: [
            AutoSizeText(
              getLabelFromAttributeName(CenteredSection.selectedAttribute),
              minFontSize: 14,
              style: TextStyle(
                color: custom_White_70,
                fontSize: 32,
              ),
            ),
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: inputHandler,
                maxLines: 1,
                style: TextStyle(
                  color: custom_White_70,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Inserisci la stringa da cercare",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_White_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: custom_Black_70,
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 140,
                  child: TextButton(
                    child: AutoSizeText(
                      "Annulla",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      minFontSize: 14,
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => {
                      widget.hpage.change_subpage(0), // Go back
                    },
                  ),
                  decoration: BoxDecoration(
                    color: custom_Black_70,
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
                ),
                Container(
                  width: 140,
                  child: TextButton(
                    child: AutoSizeText(
                      "Conferma",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      minFontSize: 14,
                      style: TextStyle(
                        color: custom_White_70,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      String inputSearch = inputHandler.text;
                      if (inputSearch == null || inputSearch.isEmpty || inputSearch == "" || inputSearch == " ") {
                        widget.hpage.change_subpage(0);
                      } else {
                        OperationContainer oc = new OperationContainer();
                        oc.addOperation(CenteredSection.selectedAttribute, inputSearch);
                        widget.hpage.change_subpage(0);
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                    color: custom_Black_70,
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
                ),
              ],
            )
          ],
        ),
      )

      // state 3 -> advanced section

      : (widget.state == 3) ? new Container(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                AttributeBigButtonSelection(
                  size: 100,
                  button_text: "Gestione aggregazione",
                  hasBorders: true,
                  callback: () {
                    widget.hpage.change_subpage(4);
                  },
                ),
              ],
            ),
            Container(
              height: 24,
            ),
            Row(
              children: [
                AttributeBigButtonSelection(
                  size: 100,
                  button_text: "Gestione ordinamenti",
                  hasBorders: true,
                  callback: () {
                    // Reindirizzamento alla pagina di Gestione ordinamenti
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: SortPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      )

      // state 4 -> aggregation section

      : (widget.state == 4) ? new Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 18, 12, 20),
          child: Column(
            children: [
              Container(
                child: AutoSizeText(
                  "Aggregazione",
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 24,
                  ),
                ),
              ),
              Expanded(child: Container(), flex: 1,),
              DropDownFormField(
                titleText: "Attributo da aggregare",
                hintText: "Scegli un attributo",
                value: choiseHandler,
                onSaved: (value) {
                  setState(() {
                    choiseHandler = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    choiseHandler = value;
                  });
                },
                dataSource: [
                  {
                    "display" : "Rank",
                    "value" : "Rank",
                  },
                  {
                    "display" : "Nome",
                    "value" : "Name",
                  },
                  {
                    "display" : "Piattaforma",
                    "value" : "Platform",
                  },
                  {
                    "display" : "Anno",
                    "value" : "Year",
                  },
                  {
                    "display" : "Genere",
                    "value" : "Genre",
                  },
                  {
                    "display" : "Publisher",
                    "value" : "Publisher",
                  },
                  {
                    "display" : "Vendite in Nord America",
                    "value" : "NA_Sales",
                  },
                  {
                    "display" : "Vendite in Europa",
                    "value" : "EU_Sales",
                  },
                  {
                    "display" : "Vendite in Giappone",
                    "value" : "JP_Sales",
                  },
                  {
                    "display" : "Vendite in altri paesi",
                    "value" : "Other_Sales",
                  },
                  {
                    "display" : "Vendite nel mondo",
                    "value" : "Global_Sales",
                  },
                ],
                textField: 'display',
                valueField: 'value',
              ),
              Expanded(child: Container(), flex: 1,),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: inputLimitHandler,
                  maxLines: 1,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Parametro limit",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_White_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_White_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_Black_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Container(height: 16,),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: inputSkipHandler,
                  maxLines: 1,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Parametro skip",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_White_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_White_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: custom_Black_70,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container(), flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    child: TextButton(
                      child: AutoSizeText(
                        "Annulla",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        minFontSize: 14,
                        style: TextStyle(
                          color: custom_White_70,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => {
                        widget.hpage.change_subpage(3), // Go back
                      },
                    ),
                    decoration: BoxDecoration(
                      color: custom_Black_70,
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
                  ),
                  Container(
                    width: 140,
                    child: TextButton(
                      child: AutoSizeText(
                        "Conferma",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        minFontSize: 14,
                        style: TextStyle(
                          color: custom_White_70,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                    decoration: BoxDecoration(
                      color: custom_Black_70,
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
                  ),
                ],
              )
            ],
          ),
        ),
      )

        // state 5 -> order section

      : (widget.state == 5) ? new Container()

      // unreachable case
      : Container( color: Colors.red, ),

    );

  }


  showAlertDialog(BuildContext context) {

    // show the dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Range di valori",
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: custom_White_70,
            fontSize: 22,
          ),
        ),
        content: Text(
          "Inserisci solo il valore iniziale per trovare tutti i record con valore maggiore o uguale;\n\n" +
              "Inserisci solo il valore finale per trovare tutti i record con valore inferiore o uguale;\n\n" +
              "Inserisci lo stesso valore in entrambi i campi per trovare i valori uguali;\n\n" +
              "Inserisci due valori diversi per trovare tutti i record con valore compreso.",
          style: TextStyle(
            color: custom_White_70,
            fontSize: 18,
          ),
        ),
        backgroundColor: custom_Black_70,
        elevation: 24.0,
      ),
      barrierDismissible: true,
    );

  }



}

