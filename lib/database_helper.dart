import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'travel_planner.db');

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Viagens (
        id INTEGER PRIMARY KEY,
        destino TEXT,
        cep TEXT,
        cidade TEXT,
        uf TEXT,
        data_partida TEXT,
        data_retorno TEXT,
        status_conclusao TEXT
      )
    ''');
  }

  Future<void> insertViagem(Map<String, dynamic> viagem) async {
    try {
      Database dbClient = await db;
      await dbClient.insert('Viagens', viagem);
      print('Viagem inserida com sucesso: $viagem');
    } catch (e) {
      print('Erro ao inserir viagem: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getViagens() async {
    Database dbClient = await db;
    return await dbClient.query('Viagens');
  }

  Future<void> updateViagem(int id, Map<String, dynamic> viagem) async {
    Database dbClient = await db;
    await dbClient.update('Viagens', viagem, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteViagem(int id) async {
    Database dbClient = await db;
    await dbClient.delete('Viagens', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getViagemById(int id) async {
    Database dbClient = await db;
    List<Map<String, dynamic>> result =
        await dbClient.query('Viagens', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Viagem não encontrada.');
    }
  }
}
