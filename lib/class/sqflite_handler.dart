import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnimalDatabaseHandler {
  static const _tableName = 'animals';
  static const _columnId = 'id';
  static const _columnTitle = 'name';

  late Database db;

  Future<void> open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'animals.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            $_columnId INTEGER PRIMARY KEY,
            $_columnTitle TEXT
          )
        ''');
      },
    );
  }

  Future<void> insert(String animalName) async {
    final data = <String, dynamic>{_columnTitle: animalName};
    await db.insert(_tableName, data);
  }

  Future<List<Map<String, dynamic>>> getAnimals(int? id) async {
    if (id != null) {
      final maps = await db.query(_tableName,
          columns: [_columnId, _columnTitle],
          where: '$_columnId = ?',
          whereArgs: [id]);

      return maps.isNotEmpty ? maps : [];
    } else {
      final maps = await db.query(_tableName,
          columns: [_columnId, _columnTitle]);

      return maps;
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(int animalId, String animalName) async {
    final data = <String, dynamic>{_columnTitle: animalName};
    return await db.update(
      _tableName,
      data,
      where: '$_columnId = ?',
      whereArgs: [animalId],
    );
  }

  Future close() async => db.close();
}
