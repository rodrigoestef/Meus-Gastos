import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum columns {
  id,
  value,
  description,
  date,
}

enum filters {
  id,
  beginDate,
  endDate,
}

class DatabaseTable {
  Database db;
  Future<void> init() async {
    String path = await getDatabasesPath();
    path = join(path, 'meusgastos.db');
    // deleteDatabase(path);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE gastos (id INTEGER PRIMARY KEY AUTOINCREMENT,value INTEGER, description STRING, date DATE,deleted INTEGER DEFAULT 0)');
      // await db.rawInsert(
      //     'INSERT INTO gastos (value,description,date) VALUES (1,"teste","2020-01-01")');
      // await db.rawInsert(
      //     'INSERT INTO gastos (value,description,date) VALUES (2,"teste","2020-01-01")');
      // await db.rawInsert(
      //     'INSERT INTO gastos (value,description,date) VALUES (3,"teste","2020-01-01")');
    });
  }

  Future<void> removeById(String id) async {
    await db.rawUpdate("UPDATE gastos set deleted = 1 WHERE id = $id");
  }

  Future<void> cancelDelete(String id) async {
    await db.rawUpdate("UPDATE gastos set deleted = 0 WHERE id = $id");
  }

  Future<List<Map<columns, String>>> getTable(
      Map<filters, String> filter) async {
    // String filter = '';
    // filter = filter[filters.id].runtimeType == String ? "and id = " : '';
    List<Map<String, Object>> res =
        await db.rawQuery('SELECT * FROM gastos WHERE deleted=0');
    return res
        .map((e) => {
              columns.id: "${e['id']}",
              columns.value: "${e['value']}",
              columns.description: "${e['description']}",
              columns.date: "${e['date']}",
            })
        .toList();
  }
}
