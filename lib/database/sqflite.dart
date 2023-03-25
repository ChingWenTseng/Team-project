import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:async';

class Health {
  //schema 數據模型
  final int? id;
  final String? name;
  final int? bloodpressure;
  final int? bloodsugar;
  final String? doctortime;

  Health(
      {this.id,
      this.name,
      this.bloodpressure,
      this.bloodsugar,
      this.doctortime});

  /*
  ---原始版 非使用json的新增---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodpressure': bloodpressure,
      'bloodsugar': bloodsugar,
      'doctortime': doctortime,
    };
  }
  */
}

class HealthDB {
  //entity 放db的所有動作
  static Database? database;

  static Future<Database?> getDBConnect() async {
    //防止重複建立
    if (database != null) {
      return database;
    }
    return await initDatabase();
  }

  static Future<Database?> initDatabase() async {
    //連接
    database = await openDatabase(
      join(await getDatabasesPath(), 'health.db'), //'health.db為db檔名
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Health(id INTEGER PRIMARY KEY, name TEXT, bloodpressure INTEGER, bloodsugar INTEGER, doctortime TEXT)",
        ); //SQLite語法 Health為table名
      },
      version: 1,
    );
    return database;
  }

  //新增
  static Future<void> inserthealth(String jsonString) async {
    database = await getDBConnect();

    //JSON轉Dart
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    //Dart新增資料庫
    for (final json in jsonList) {
      await database!.insert(
        'Health',
        {
          'id': json['id'],
          'name': json['name'],
          'bloodpressure': json['bloodpressure'],
          'bloodsugar': json['bloodsugar'],
          'doctortime': json['doctortime']
        },
        conflictAlgorithm: ConflictAlgorithm.replace, //若有衝突覆蓋原先資料
      );
    }
    await database?.close();
  }

  //讀
  static Future<List<Health>> getHealthList() async {
    database = await getDBConnect();
    final List<Map<String, dynamic>> maps = await database!.query('Health');
    return List.generate(maps.length, (i) {
      return Health(
          id: maps[i]['id'],
          name: maps[i]['name'],
          bloodpressure: maps[i]['bloodpressure'],
          bloodsugar: maps[i]['bloodsugar'],
          doctortime: maps[i]['dactortime']);
    });
  }

  //透過id更新
  static Future<void> updateHealh(Health health) async {
    database = await getDBConnect();
    await database!.update(
      'Health',
      {
        'name': health.name,
        'bloodpressure': health.bloodpressure,
        'bloodsugar': health.bloodsugar,
        'doctortime': health.doctortime
      },
      where: 'id = ?',
      whereArgs: [health.id],
    );
  }

  //透過id刪除
  static Future<void> deleteHealth(int id) async {
    database = await getDBConnect();
    await database!.delete(
      'Health',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /* 
  ---原始版 非使用json的新增---
  static Future<void> insertHealth(Health health) async {
    database = await getDBConnect();
    await database!.insert(
      'Health',
      health.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } 
  */
}
