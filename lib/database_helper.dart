import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'voting_dart.dart';

const String tableVoting = 'voting';
const String tableVotingHistory = 'votingHistory';

class DatabaseHelper {
static final DatabaseHelper instance = DatabaseHelper._init();

static Database? _database;

DatabaseHelper._init();

Future<Database> get database async {
if (_database != null) return _database!;

_database = await _initDB('votings.db');
return _database!;
}

Future<Database> _initDB(String filePath) async {
final dbPath = await getDatabasesPath();
final path = join(dbPath, filePath);

return await openDatabase(
path,
version: 1,
onCreate: _createDB,
);
}

Future _createDB(Database db, int version) async {
const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
const textType = 'TEXT NOT NULL';

await db.execute('''
    CREATE TABLE $tableVoting (
      ${VotingFields.id} $idType,
      ${VotingFields.question} $textType,
      ${VotingFields.options} $textType,
      ${VotingFields.votes} $textType
    )
    ''');

await db.execute('''
    CREATE TABLE $tableVotingHistory (
      ${VotingFields.id} $idType,
      ${VotingFields.question} $textType,
      ${VotingFields.options} $textType,
      ${VotingFields.votes} $textType
    )
    ''');
}

Future<Voting> create(Voting voting) async {
final db = await instance.database;

final id = await db.insert(tableVoting, voting.toJson());
return voting.copy(id: id);
}

Future<Voting?> readVoting(int id) async {
final db = await instance.database;

final maps = await db.query(
tableVoting,
columns: VotingFields.values,
where: '${VotingFields.id} = ?',
whereArgs: [id],
);

if (maps.isNotEmpty) {
return Voting.fromJson(maps.first);
} else {
return null;
}
}

Future<int> update(Voting voting) async {
final db = await instance.database;

return db.update(
tableVoting,
voting.toJson(),
where: '${VotingFields.id} = ?',
whereArgs: [voting.id],
);
}

Future<int> delete(int id) async {
final db = await instance.database;

return await db.delete(
tableVoting,
where: '${VotingFields.id} = ?',
whereArgs: [id],
);
}

Future<Voting?> getCurrentVoting() async {
final db = await instance.database;

final maps = await db.query(
tableVoting,
columns: VotingFields.values,
limit: 1,
);

if (maps.isNotEmpty) {
return Voting.fromJson(maps.first);
} else {
return null;
}
}

Future<void> deleteCurrentVoting() async {
final db = await instance.database;
await db.delete(tableVoting);
}

Future<void> addToHistory(Voting voting) async {
final db = await instance.database;
await db.insert(tableVotingHistory, voting.toJson());
}

Future<List<Voting>> getVotingHistory() async {
final db = await instance.database;

final result = await db.query(tableVotingHistory);

return result.map((json) => Voting.fromJson(json)).toList();
}

Future close() async {
final db = await instance.database;

db.close();
}
}
