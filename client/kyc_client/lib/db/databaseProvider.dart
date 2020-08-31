import 'package:flutter/cupertino.dart';
import 'package:kyc_client/models/contacttrace.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:path/path.dart';

class DatabaseProvider extends ChangeNotifier {
  static const String DATABASE_NAME = 'covidtrace.db';
  static const String TABLE_NAME = 'journey';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_JOURNEYCODE = 'journeycode';
  static const String COLUMN_RIDER = 'rider';
  static const String COLUMN_CLIENT = 'client';
  static const String COLUMN_SOURCE = 'source';
  static const String COLUMN_DESTINATION = 'destination';
  static const String COLUMN_PICKUPTIME = 'pickuptime';
  static const String COLUMN_PICKUPDATE = 'pickupdate';
  static const String COLUMN_INFECTED = 'infected';
  static const String COLUMN_UPLOADED = 'uploaded';

  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    String fullpath = join(dbPath, DATABASE_NAME);
    return await openDatabase(
      fullpath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME (
      $COLUMN_ID INTEGER PRIMARY KEY,
      $COLUMN_JOURNEYCODE TEXT NOT NULL,
      $COLUMN_RIDER TEXT NOT NULL,
      $COLUMN_CLIENT TEXT NOT NULL,
      $COLUMN_SOURCE TEXT NOT NULL,
      $COLUMN_DESTINATION TEXT NOT NULL,
      $COLUMN_PICKUPTIME TEXT NOT NULL,
      $COLUMN_PICKUPDATE TEXT NOT NULL,
      $COLUMN_INFECTED INTEGER NOT NULL,
      $COLUMN_UPLOADED INTEGER NOT NULL
      )''');
  }

  // All Contacts
  List<ContactTrace> contactList = List<ContactTrace>();
  List<ContactTrace> contactsToday = List<ContactTrace>();
  List<ContactTrace> contactsInfected = List<ContactTrace>();

  List<ContactTrace> get allcontacts => contactList;
  List<ContactTrace> get today => contactsToday;
  List<ContactTrace> get infected => contactsInfected;

  void getJourneys() async {
    final db = await database;
    List<Map<String, dynamic>> contacts = await db.query(TABLE_NAME, columns: [
      COLUMN_ID,
      COLUMN_JOURNEYCODE,
      COLUMN_SOURCE,
      COLUMN_DESTINATION,
      COLUMN_CLIENT,
      COLUMN_RIDER,
      COLUMN_PICKUPTIME,
      COLUMN_INFECTED,
      COLUMN_UPLOADED
    ]);

    contacts.forEach((currentContact) {
      ContactTrace contact = ContactTrace.fromJson(currentContact);
      contactList.add(contact);
    });
    notifyListeners();
  }

  // Create Contact

  void insert(ContactTrace newContact) async {
    final db = await database;
    newContact.id = await db.insert(TABLE_NAME, newContact.toJson());
    contactList.add(newContact);
    contactsToday.add(newContact);
    notifyListeners();
  }

  void getAllContacts() async {
    final db = await database;
    final contacts = await db.query(TABLE_NAME);
    contacts
        .map((contact) => contactList.add(ContactTrace.fromJson(contact)))
        .toList();
    notifyListeners();
  }

  void getTodayContacts(String pickuptime) async {
    final db = await database;
    final contacts = await db.query(TABLE_NAME,
        where: "pickupdate = ?", whereArgs: [pickuptime.substring(0, 10)]);
    contacts
        .map((contact) => contactsToday.add(ContactTrace.fromJson(contact)))
        .toList();
    notifyListeners();
  }

  void getInfectedContacts() async {
    final db = await database;
    final contacts =
        await db.query(TABLE_NAME, where: "infected ==?", whereArgs: [1]);
    contacts
        .map((contact) => contactsInfected.add(ContactTrace.fromJson(contact)))
        .toList();
    notifyListeners();
  }
}
