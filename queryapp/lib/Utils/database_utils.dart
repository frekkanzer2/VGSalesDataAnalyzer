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
    return await collection.find(oc.getFormattedQuery()).toList();
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

}