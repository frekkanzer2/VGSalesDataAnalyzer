import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:queryapp/Beans/database_data.dart';
import 'package:queryapp/Beans/operation_container.dart';

class DatabaseUtils {

  static Future<List<Map<String, dynamic>>> executeQuery() async {
    var _db = await Db.create(databaseAddress);
    await _db.open();
    OperationContainer oc = new OperationContainer();
    final collection = _db.collection(collection_name);
    if (!oc.ordering_isActive()) return await collection.find(oc.getFormattedQuery()).toList();
    else {
      List<Map<String, dynamic>> retrieved = await collection.find(oc.getFormattedQuery()).toList();
      return _mergeSort(retrieved);
    }
  }

  static Future<Map> executeAggregate() async {
    var _db = await Db.create(databaseAddress);
    await _db.open();
    OperationContainer oc = new OperationContainer();
    final collection = _db.collection(collection_name);
    var pip = [];
    pip.add({ r"$match" : { oc.aggregation_getAttribute() : {r"$regex": oc.aggregation_getAttributeValue()} }});
    if (oc.aggregation_getLimit() > 0)
      pip.add({ r"$limit" : oc.aggregation_getLimit() });
    if (oc.aggregation_getSkip() > 0)
      pip.add({ r"$skip" : oc.aggregation_getSkip() });
    Map aggregateResult = await collection.aggregate(pip, cursor: {});
    return aggregateResult;
  }

  static List<Map<String, dynamic>> _mergeSort (List<Map<String, dynamic>> input) {
    int n = input.length;
    if (n == 1) return input;

    List<Map<String, dynamic>> left, right;
    int separator = (n/2).floor();

    List<List<Map<String, dynamic>>> cutResult = _cut(input);
    left = cutResult[0];
    right = cutResult[1];

    left = _mergeSort(left);
    right = _mergeSort(right);

    return _merge(left, right);
  }

  static List<List<Map<String, dynamic>>> _cut(List<Map<String, dynamic>> input) {
    List<Map<String, dynamic>> left = [];
    List<Map<String, dynamic>> right = [];
    int dimension = input.length;
    int separator = (dimension/2).round();
    int index = 0;
    while(index < dimension) {
      if (index < separator) {
        left.insert(left.length, input[index]);
      } else {
        right.insert(right.length, input[index]);
      }
      index++;
    }
    print("NEW ITERATION");
    print(left.length);
    print(right.length);
    return [left, right];
  }

  static List<Map<String, dynamic>> _merge (List<Map<String, dynamic>> a, List<Map<String, dynamic>> b) {

    List<Map<String, dynamic>> result = [];
    OperationContainer oc = new OperationContainer();

    while(a.length > 0 && b.length > 0) {
      if (oc.ordering_getSense() > 0) {
        // Ascending
        if (_check(a[0], ">", b[0], oc)) {
          result.insert(result.length, b[0]);
          b.removeAt(0);
        } else {
          result.insert(result.length, a[0]);
          a.removeAt(0);
        }
      } else {
        // Discending
        if (_check(a[0], "<", b[0], oc)) {
          result.insert(result.length, b[0]);
          b.removeAt(0);
        } else {
          result.insert(result.length, a[0]);
          a.removeAt(0);
        }
      }
    }

    while(a.length > 0){
      result.insert(result.length, a[0]);
      a.removeAt(0);
    }

    while(b.length > 0){
      result.insert(result.length, b[0]);
      b.removeAt(0);
    }

    return result;

  }

  static bool _check(Map<String, dynamic> a, String compareSymbol, Map<String, dynamic> b, OperationContainer oc) {
    String attributeToCheck = oc.ordering_getAttribute();
    if (compareSymbol == ">") {
      return (a[attributeToCheck] > b[attributeToCheck]);
    } else if (compareSymbol == "<") {
      return (a[attributeToCheck] < b[attributeToCheck]);
    } else throw new Exception("Symbol not managed");
  }

}