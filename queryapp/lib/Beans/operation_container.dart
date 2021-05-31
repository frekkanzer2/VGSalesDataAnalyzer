class OperationContainer {

  static List<String> _selectedOperations = [];
  static List<String> _attributes = [];
  static Map<String, dynamic> _formattedQuery = new Map();

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