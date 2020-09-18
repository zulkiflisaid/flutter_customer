 
 
import 'package:pelanggan/model/history_cari.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
 
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;  

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {

  //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pelanggan.db';

   //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

    //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE historycari (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, 
        tgl TEXT 
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('historycari', orderBy: ' tgl DESC');
    return mapList;
  }

//create databases
  Future<int> insert(HistoryCari object) async {
    Database db = await this.database;
    int count = await db.insert('historycari', object.toMap());
    return count;
  }
//update databases
  Future<int> update(HistoryCari object) async {
    Database db = await this.database;
    int count = await db.update('historycari', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('historycari', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }

  Future<List<HistoryCari>> getContactList() async {
    var contactMapList = await select();
    int count = contactMapList.length;
    List<HistoryCari> contactList = List<HistoryCari>();
    for (int i=0; i<count; i++) {
      contactList.add(HistoryCari.fromMap(contactMapList[i]));
    }
    return contactList;
  }

}