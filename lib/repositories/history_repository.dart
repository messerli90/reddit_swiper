import 'dart:async';

import 'package:path/path.dart';
import 'package:reddit_pics/models/History.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  return openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE history(id INTEGER PRIMARY KEY, subreddit TEXT, img_url INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> insertHistory(History history) async {
  final Database db = await getDatabase();

  var existing = await db.query('history',
      where: 'subreddit = ?', whereArgs: ['aww'], limit: 1);

  if (existing.length > 0) {
    // update
    await db.update('history', history.toMap(),
        where: 'id = ?', whereArgs: [existing[0]['id']]);
  } else {
    // insert
    await db.insert('history', history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

Future<List<History>> getHistory() async {
  final Database db = await getDatabase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('history');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return History(
      id: maps[i]['id'],
      subreddit: maps[i]['subreddit'],
      imgUrl: maps[i]['img_url'],
    );
  });
}

Future<void> deleteHistory(int id) async {
  // Get a reference to the database.
  final db = await getDatabase();

  // Remove the Dog from the database.
  await db.delete(
    'history',
    // Use a `where` clause to delete a specific dog.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<void> deleteAll() async {
  final db = await getDatabase();

  await db.delete('history');
}
