import 'package:sqflite/sqflite.dart';

class DatabaseTable {

  Future<void> createTable(Database db,) async {
    await db.execute(
      "CREATE TABLE customer("
          "id INTEGER PRIMARY KEY,"
          "customerName TEXT NOT NULL,"
          "customerPhone TEXT NOT NULL,"
          "customerBirthday INTEGER NOT NULL,"
          "addedAt INTEGER NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE position("
          "id INTEGER PRIMARY KEY,"
          "positionName TEXT NOT NULL,"
          "positionPrice DOUBLE NOT NULL,"
          "addedAt INTEGER NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE cart("
          "id INTEGER PRIMARY KEY,"
          "customerId INTEGER NOT NULL,"
          "positionId INTEGER NOT NULL,"
          "positionName TEXT NOT NULL,"
          "positionPrice DOUBLE NOT NULL,"
          "positionQty DOUBLE NOT NULL,"
          "positionAmount DOUBLE NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE orders("
          "id INTEGER PRIMARY KEY,"
          "customerId INTEGER NOT NULL,"
          "customerName TEXT NOT NULL,"
          "customerPhone TEXT NOT NULL,"
          "addedAt INTEGER NOT NULL,"
          "acceptDate INTEGER NOT NULL,"
          "shipmentDate INTEGER NOT NULL,"
          "orderStatus INTEGER NOT NULL,"
          "invoice INTEGER NOT NULL,"
          "totalSum DOUBLE NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE ordered_positions("
          "id INTEGER PRIMARY KEY,"
          "customerId INTEGER NOT NULL,"
          "positionId INTEGER NOT NULL,"
          "positionName TEXT NOT NULL,"
          "positionPrice DOUBLE NOT NULL,"
          "positionQty DOUBLE NOT NULL,"
          "positionAmount DOUBLE NOT NULL,"
          "orderId INTEGER NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE expense_tb("
          "id INTEGER PRIMARY KEY,"
          "expense TEXT NOT NULL,"
          "expenseCategory TEXT NOT NULL,"
          "expenseSum DOUBLE NOT NULL,"
          "expenseDescription TEXT NOT NULL,"
          "addedAt INTEGER NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE bank_tb("
          "id INTEGER PRIMARY KEY,"
          "admission TEXT NOT NULL,"
          "expense TEXT NOT NULL,"
          "admissionSum DOUBLE NOT NULL,"
          "expenseSum DOUBLE NOT NULL,"
          "admissionDescription TEXT NOT NULL,"
          "expenseDescription TEXT NOT NULL,"
          "addedAt INTEGER NOT NULL,"
          "expAt INTEGER NOT NULL)",
    );
  }


}
