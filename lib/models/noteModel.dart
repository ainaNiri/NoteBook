import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db{
  late Database db;
  // Define a function that inserts dogs into the database
  Future<void> insertNote(Note note) async {

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Note>> getNotes() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
      db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'notes3_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (database, version) async{
        // Run the CREATE TABLE statement on the database.
        await database.execute(
          'CREATE TABLE  notes(id INTEGER PRIMARY KEY , title TEXT, content TEXT, date TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Query the table for all The Dogs.
    List<Map<String, dynamic>> maps = await db.query("notes");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: DateTime.parse(maps[i]['date'])
      );
    });
  }

  Future<void> updateNote(int id, Note note) async {

    // Update the given Dog.
    await db.update(
      'notes',
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    // Remove the Dog from the database.
    await db.delete(
      'notes',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
class Note {
  late int? id;
  late  String title;
  late String content;
  late DateTime date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toString()
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, data: ${date.toString()}}';
  }
}
List <Note> notes= [];