import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:queryapp/Beans/database_data.dart';
import 'package:queryapp/Beans/operation_container.dart';

class DatabaseUtils {

  static Future<List<Map<String, dynamic>>> executeQuery() async {
    var _db = await Db.create(databaseAddress);
    await _db.open();
    if (!_db.isConnected) print("Database is NOT connected");
    OperationContainer oc = new OperationContainer();
    final collection = _db.collection(collection_name);
    return await collection.find(oc.getFormattedQuery()).toList();
  }

}