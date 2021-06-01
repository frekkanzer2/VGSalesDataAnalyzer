class OperationContainer {

  static List<String> _selectedOperations = [];
  static List<String> _attributes = [];
  static Map<String, dynamic> _formattedQuery = new Map();

  // Aggregation variables
  static bool _aggregationEnabled = false;
  static int _aggregation_limit = -1;
  static int _aggregation_skip = -1;
  static String _aggregation_attribute = "";
  static String _aggregation_attribute_value = "";
  static String _aggregationError = "";
  static String _totalAggregateItems = "";

  // Order variables
  static int _orderValue = 0; // -1 decr; 0 no ordering; +1 cresc
  static String _orderAttribute = "";

  void aggregation_setNumbItems(String items) {
    _totalAggregateItems = items;
  }

  String aggregation_getNumbItems() {
    return _totalAggregateItems;
  }

  String ordering_getOutput() {
    String builder = "";
    if (_orderAttribute != "") builder += "\$order : " + _orderAttribute;
    else builder += "Attribute not selected";
    if (_orderValue > 0) builder += "\n\$type : ascending";
    else if (_orderValue < 0) builder += "\n\$type : discending";
    else builder += "\nOrdering type not selected";
    if (ordering_isActive()) builder += "\n\nORDERING ENABLED";
    else builder += "\n\nORDERING DISABLED";
    return builder;
  }

  void ordering_reset() {
    _orderAttribute = "";
    _orderValue = 0;
  }

  bool ordering_isActive() {
    if (_orderValue != 0 && _orderAttribute != "") return true;
    else return false;
  }

  void ordering_setAttribute(String attr) {
    _orderAttribute = attr;
  }

  String ordering_getAttribute() {
    return _orderAttribute;
  }

  void ordering_setSense(int value) {
    _orderValue = value;
  }

  int ordering_getSense() {
    return _orderValue;
  }

  void aggregation_setError(String err) {
    _aggregationError = err;
  }

  String aggregation_getError(bool delete) {
    if (delete) {
      String err = _aggregationError;
      _aggregationError = "";
      return err;
    } else return _aggregationError;
  }

  String aggregation_getOutput() {
    String buffer = "";
    if (!_aggregationEnabled) buffer = "Nessuna aggregazione attiva";
    else {
      buffer += "\$match : { " + _aggregation_attribute + " : " + _aggregation_attribute_value + " }";
      if (_aggregation_limit > 0) buffer += "\n\$limit : " + _aggregation_limit.toString();
      if (_aggregation_skip > 0) buffer += "\n\$skip : " + _aggregation_skip.toString();
    }
    return buffer;
  }

  bool aggregation_isEnabled() {
    return _aggregationEnabled;
  }

  void aggregation_setEnabled(bool isEnabled) {
    _aggregationEnabled = isEnabled;
  }

  void aggregation_setAttribute(String attr) {
    if (_aggregationEnabled) _aggregation_attribute = attr;
    else _aggregation_attribute = "";
  }

  String aggregation_getAttribute() {
    if (_aggregationEnabled) return _aggregation_attribute;
    return "";
  }

  void aggregation_setAttributeValue(String value) {
    if (_aggregationEnabled) _aggregation_attribute_value = value;
    else _aggregation_attribute_value = "";
  }

  String aggregation_getAttributeValue() {
    if (_aggregationEnabled) return _aggregation_attribute_value;
    return "";
  }

  void aggregation_setLimit(int limit) {
    if (_aggregationEnabled) _aggregation_limit = limit;
    else _aggregation_limit = -1;
  }

  int aggregation_getLimit() {
    if (_aggregationEnabled) return _aggregation_limit;
    return -1;
  }

  void aggregation_setSkip(int skip) {
    if (_aggregationEnabled) _aggregation_skip = skip;
    else _aggregation_skip = -1;
  }

  int aggregation_getSkip() {
    if (_aggregationEnabled) return _aggregation_skip;
    return -1;
  }

  void addOperation(String attributeName, String input) {
    _formattedQuery[attributeName] = {r"$regex": input};
    if (_attributes.contains(attributeName)) {
      int index = _attributes.indexOf(attributeName);
      _selectedOperations[index] = attributeName + " : " + input;
    } else {
      _attributes.add(attributeName);
      _selectedOperations.add(attributeName + " : " + input);
    }
  }
  
  void addOperationRange(String attributeName, String startRange, String endRange) {
    // Add in map
    if (startRange != "" && endRange != "")
      _formattedQuery[attributeName] = { r"$gte" : int.parse(startRange), r"$lte" : int.parse(endRange) };
    else if (startRange != "")
      _formattedQuery[attributeName] = { r"$gte" : int.parse(startRange) };
    else if (endRange != "")
      _formattedQuery[attributeName] = { r"$lte" : int.parse(endRange) };
    // Add in display list
    if (_attributes.contains(attributeName)) {
      // already has attribute in list
      int index = _attributes.indexOf(attributeName);
      if (startRange != "" && endRange != "")
        _selectedOperations[index] = attributeName + " : { \$gte : " +
            startRange.toString() + ", \$lte : " + endRange.toString() + " }";
      else if (startRange != "")
        _selectedOperations[index] = attributeName + " : { \$gte : " +
            startRange.toString() + " }";
      else if (endRange != "")
        _selectedOperations[index] = attributeName + " : { \$lte : " +
            endRange.toString() + " }";
    } else {
      // adding new attribute
      _attributes.add(attributeName);
      if (startRange != "" && endRange != "")
        _selectedOperations.add(attributeName + " : { \$gte : " +
            startRange.toString() + ", \$lte : " + endRange.toString() + " }"
        );
      else if (startRange != "")
        _selectedOperations.add(attributeName + " : { \$gte : " +
            startRange.toString() + " }"
        );
      else if (endRange != "")
        _selectedOperations.add(attributeName + " : { \$lte : " +
            endRange.toString() + " }"
        );
    }
  }

  void removeOperation(int index) {
    _selectedOperations.removeAt(index);
    String _attr = _attributes[index];
    _attributes.removeAt(index);
    _formattedQuery.removeWhere((key, value) => key == _attr);
  }

  String getOperation(int index) {
    return _selectedOperations[index];
  }

  List<String> getOperations() {
    return _selectedOperations;
  }

  void reset() {
    _selectedOperations.clear();
    _attributes.clear();
    _formattedQuery = new Map();
  }

  String getQuery() {
    String _buffer_query = "";
    for (int i = 0; i < _selectedOperations.length; i++) {
      if (i == _selectedOperations.length-1) {
        _buffer_query += getOperation(i);
      } else {
        // add comma
        _buffer_query += getOperation(i) + ", ";
      }
    }
    return "{" + _buffer_query + "}";
  }

  Map<String, dynamic> getFormattedQuery() {
    print(_formattedQuery);
    return _formattedQuery;
  }

}