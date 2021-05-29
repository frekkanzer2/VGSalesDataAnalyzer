class OperationContainer {

  static List<String> _selectedOperations = [];

  void addOperation(String attributeName, String input) {
    _selectedOperations.add(attributeName + " : \"" + input + "\"");
  }
  
  void addOperationRange(String attributeName, String startRange, String endRange) {
    if (startRange != "" && endRange != "")
      _selectedOperations.add(attributeName + " : { \$gte : " +
          startRange.toString() + ", \$lte : " + endRange.toString() + " }"
      );
    else if (startRange != "") {
      _selectedOperations.add(attributeName + " : { \$gte : " +
          startRange.toString() + " }"
      );
    } else if (endRange != "") {
      _selectedOperations.add(attributeName + " : { \$lte : " +
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

}