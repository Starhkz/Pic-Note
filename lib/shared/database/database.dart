import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class PicDataBase extends ChangeNotifier {
  Future<Database> initDB() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), picNoteDB),
      // When the database is first created, create a table to store notes.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $picNote($cId INTEGER PRIMARY KEY, $cTitle TEXT, $cSubtitle TEXT, $cDate TEXT, $cImageURL TEXT, $cTag TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
      // UPGRADE DATABASE TABLES
    );
    return database;
  }

  // ignore: unused_element
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE tabEmployee ADD COLUMN newCol TEXT;");
    }
  }

  Future<Database> initID() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), currentIdDB),
      // When the database is first created, create a table to store notes.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $picNote($cId INTEGER PRIMARY KEY, $cCurrentID INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<void> insertNote(Note note) async {
    // Get a reference to the database.

    final db = await initDB();
    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      picNote,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final prefs = await SharedPreferences.getInstance();
    int currentId = prefs.getInt(cCurrentID) ?? 0;
    int newId = currentId + 1;
    await prefs.setInt(cCurrentID, newId);
    notifyListeners();
  }

  /// Delete a Note from the DataBase
  /// Deleted notes cannot be restored.
  /// Be careful when calling this function.
  removeNote(int id) async {
    final db = await initDB();
    await db.delete(picNote, where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  /// Updates the note with the given ID in the database
  editNote(Note note) async {
    final db = await initDB();
    await db
        .update(picNote, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    notifyListeners();
  }

  /// Returns a list of [Note]s from the Database
  Future<List<Note>> getNotes() async {
    List<Note> notes = [];
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(picNote);
    notes = mapToNote(maps);
    return notes;
  }

  /// Returns the tags for a [Note] from the Database.
  /// Index refers to the ID of the note
  Future<List<String>> getTags(int index) async {
    List<Note> notes = [];
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(picNote);
    notes = mapToNote(maps);
    List<String> tags = notes[index].tags!;
    return tags;
  }

  // For Note Media
  Future<Database> initNMDB() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), picNoteMediaDB),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $picNoteMedia($cId INTEGER PRIMARY KEY, $cTitle TEXT, $cSubtitle TEXT, $cDate TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<Database> initNMID() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), curentMediaDB),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $picNoteMedia($cId INTEGER PRIMARY KEY, $cCurrentID INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }
}
