class OperationContainer {

  static List<String> _selectedOperations = [];

  void addOperation(String attributeName, String input) {
    _selectedOperations.add("\"" + attributeName + "\" : \"" + input + "\"");
  }
  
  void addOperationRange(String attributeName, String startRange, String endRange) {
    if (startRange != "" && endRange != "")
      _selectedOperations.add("\"" + attributeName + "\" : { \"\$gte\" : " +
          startRange.toString() + ", \"\$lte\" : " + endRange.toString() + " }"
      );
    else if (startRange != "") {
      _selectedOperations.add("\"" + attributeName + "\" : { \"\$gte\" : " +
          startRange.toString() + " }"
      );
    } else if (endRange != "") {
      _selectedOperations.add("\"" + attributeName + "\" : { \"\$lte\" : " +
          endRange.toString() + " }"
      );
    }
  }

  void removeOperation(int index) {
    _selectedOperations.removeAt(index);
  }

  String getOperation(int index) {
    return _selectedOperations[index];
  }

  List<String> getOperations() {
    return _selectedOperations;
  }

  void reset() {
    _selectedOperations.clear();
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

}