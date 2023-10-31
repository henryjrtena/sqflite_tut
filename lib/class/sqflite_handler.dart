import 'package:sqflite/sqflite.dart';

class AnimalDatabaseHandler {
  static const _dbPath = 'animals.db';
  static const _tableName = 'animals';
  static const _columnId = 'id';
  static const _columnTitle = 'name';

  late Database db;

  Future<Database> open() async {
    db = await openDatabase(_dbPath, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
                      create table $_tableName ( 
                        $_columnId integer primary key autoincrement, 
                        $_columnTitle text not null)
                      ''');
    });

    return db;
  }

  Future<void> insert(String animalName) async => db.insert(_tableName, {_columnId: null, _columnTitle: animalName});

  Future<List<Map<dynamic, dynamic>>> getAnimals(int? id) async {
    if (id != null) {
      List<Map> maps = await db.query(_tableName, columns: [_columnId], where: '$_columnId = ?', whereArgs: [id]);

      return maps.isNotEmpty ? maps : List.empty();
    }

    List<Map> maps = await db.query(_tableName, columns: [_columnId, _columnTitle]);

    return maps;
  }

  Future<int> delete(int id) async {
    return await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> update(int animalId) async {
    return await db.update(_tableName, {_columnId: animalId}, where: '$_columnId = ?', whereArgs: [animalId]);
  }

  Future close() async => db.close();
}
