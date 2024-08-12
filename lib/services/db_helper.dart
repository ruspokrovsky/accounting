import 'dart:io';
import 'package:forleha/models/bank_model.dart';
import 'package:forleha/models/cart_model.dart';
import 'package:forleha/models/customer_model.dart';
import 'package:forleha/models/expense_model.dart';
import 'package:forleha/models/order_model.dart';
import 'package:forleha/models/position_model.dart';
import 'package:forleha/services/db_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {

  static Future<int> addCustomer(CustomerModel customerData) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("customer", customerData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addPosition(PositionModel positionData) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("position", positionData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addPositionToCart(CartModel cartData) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("cart", cartData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addOrderedPosition(CartModel cartData) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("ordered_positions", cartData.toJsonForOrders(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateOrderedPosition(CartModel positionData) async {
    final Database db = await DatabaseManager().database;
    return await db.update(
      "ordered_positions",{
        'positionPrice': positionData.positionPrice,
        'positionQty': positionData.positionQty,
        'positionAmount': positionData.positionAmount,},
      where: 'id = ?',
      whereArgs: [positionData.id],
    );
  }

  static Future<int> deleteOrderedPosition({required CartModel positionData}) async {
    final Database db = await DatabaseManager().database;
    return await db.delete(
      "ordered_positions",
      where: 'id = ?',
      whereArgs: [positionData.id],
    );
  }

  static Future<void> updateCustomer({
    required CustomerModel customerData,
    // Добавьте другие поля, которые вы хотите обновить
  }) async {
    final Database db = await DatabaseManager().database;
    await db.update(
      "customer", customerData.toJson(),
      where: 'id = ?',
      whereArgs: [customerData.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  //-----------------------------------------------------------------------


  static Future<void> deleteOrderAndPositions(OrderModel orderModel) async {
    final Database db = await DatabaseManager().database;

    try {
      await db.transaction((txn) async {
        // Удаляем позиции заказа из таблицы 'ordered_positions' по orderId
        await txn.delete(
          'ordered_positions',
          where: 'orderId = ?',
          whereArgs: [orderModel.id],
        );

        // Удаляем заказ из таблицы 'orders' по его id
        await txn.delete(
          'orders',
          where: 'id = ?',
          whereArgs: [orderModel.id],
        );
      });
    } catch (e) {
      // Обработка ошибок транзакции
      print('Error deleting order and positions: $e');
      rethrow;
    }
  }



  //-----------------------------------------------------------------------

  static Future<List<CustomerModel>> getAllCustomer() async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps = await db.query("customer",orderBy: "addedAt DESC");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => CustomerModel.fromJson(maps[index]));
  }

  static Future<int> deleteCustomer({required CustomerModel customerModel}) async {
    final Database db = await DatabaseManager().database;
    return await db.delete(
      "customer",
      where: 'id = ?',
      whereArgs: [customerModel.id],
    );
  }


  static Future<List<PositionModel>> getAllPosition() async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps = await db.query("position");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => PositionModel.fromJson(maps[index]));
  }

  static Future<List<CartModel>> getCart() async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps = await db.query("cart");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => CartModel.fromJson(maps[index]));
  }

  static Future<List<OrderModel>> getOrders() async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps = await db.query("orders",orderBy: "addedAt DESC");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => OrderModel.fromJson(maps[index]));
  }

  static Future<List<BankModel>> getBank() async {
    final Database db = await DatabaseManager().database;
    final List<Map<String, dynamic>> maps = await db.query("bank_tb",orderBy: "addedAt DESC");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => BankModel.fromJson(maps[index]));
  }

  static Future<List<OrderModel>> getOrdersByCustomerId({required int customerId}) async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps
    = await db.query("orders",where: "customerId = ?",
      whereArgs: [customerId],);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => OrderModel.fromJson(maps[index]));
  }


  static Future<int> deleteCartPosition(CartModel cartModel) async {
    final Database db = await DatabaseManager().database;
    return await db.delete(
      "cart",
      where: 'id = ?',
      whereArgs: [cartModel.id],
    );
  }

  static Future<int> deletePosition(PositionModel positionModel) async {
    final Database db = await DatabaseManager().database;
    return await db.delete(
      "position",
      where: 'id = ?',
      whereArgs: [positionModel.id],
    );
  }


  static Future<int> addOrder(OrderModel orderModel) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("orders", orderModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  static Future<int> addOrderPositions(List<CartModel?>? cartDataList) async {
    final Database db = await DatabaseManager().database;

    for (var element in cartDataList!) {
      await db.insert("ordered_positions", element!.toJsonForOrders(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return 6;
  }

  static Future<List<CartModel>> getOrderPositions({
    required OrderModel args}) async {
    final Database db = await DatabaseManager().database;
    final List<Map<String, dynamic>> maps = await db.query("ordered_positions",
      where: "orderId = ?",
      whereArgs: [args.id],);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => CartModel.fromJson(maps[index]));
  }

  static Future<List<CartModel>> getAllOrderedPositions({
    required CustomerModel args}) async {
    final Database db = await DatabaseManager().database;
    final List<Map<String, dynamic>> maps = await db.query("ordered_positions",
      where: "customerId = ?",
      whereArgs: [args.id],);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => CartModel.fromJson(maps[index]));
  }

  static Future<void> updateOrderStatus({
    required int orderId,
    required int status,
  }) async {
    final Database db = await DatabaseManager().database;
    int updateDate = DateTime.now().millisecondsSinceEpoch;

    if(status == 0){
      await db.update(
        "orders",
        {'orderStatus': status,'addedAt': updateDate,},
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
    else if(status == 1){
      await db.update(
        "orders",
        {'orderStatus': status,'shipmentDate': updateDate,},
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
    else if(status == 2){
      await db.update(
        "orders",
        {'orderStatus': status,'acceptDate': updateDate,},
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
}


  static Future<void> clearCart() async {
    final Database db = await DatabaseManager().database;
    await db.delete('cart'); // Удаляем все строки из таблицы "cart"
  }

  static Future<int> addExpense(ExpenseModel expenseModel) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("expense_tb", expenseModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addAdmission(BankModel bankModel) async {
    final Database db = await DatabaseManager().database;
    return await db.insert("bank_tb", bankModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ExpenseModel>> getExpense() async {
    final Database db = await DatabaseManager().database;

    final List<Map<String, dynamic>> maps = await db.query("expense_tb",orderBy: "addedAt DESC");
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
        maps.length, (index) => ExpenseModel.fromJson(maps[index]));
  }

  static Future<int> deleteExpense({required ExpenseModel expenseModel}) async {
    final Database db = await DatabaseManager().database;
    return await db.delete(
      "expense_tb",
      where: 'id = ?',
      whereArgs: [expenseModel.id],
    );
  }







// static Future<List<CartModel>> getOrderPositions({
  //   required OrderModel args}) async {
  //   final Database db = await DatabaseManager().database;
  //   final List<Map<String, dynamic>> maps = await db.query("ordered_positions",
  //     where: "id = ? AND invoice = ?",
  //     whereArgs: [args.id, args.invoice],);
  //   if (maps.isEmpty) {
  //     return [];
  //   }
  //   return List.generate(
  //       maps.length, (index) => CartModel.fromJson(maps[index]));
  // }

// Получаем текущую версию базы данных


  static Future<int> getCurrentVersion() async {
    final Database db = await DatabaseManager().database;
    return await db.getVersion();
  }

  static Future<String> getDbPath() async {

    String databasePath = await getDatabasesPath();
    print('databasePath: $databasePath');
    Directory? externalStoragePath  = await getExternalStorageDirectory();
    print('externalStoragePath: $externalStoragePath');

return databasePath;
  }

  static Future<void> backupDb() async {

    var status = await Permission.manageExternalStorage.status;

    if(!status.isGranted){
      await Permission.manageExternalStorage.request();
    }

    var status1 = await Permission.storage.status;

    if(!status1.isGranted){
      await Permission.storage.request();

    }

    try{
      File savedDb = File("/data/user/0/com.example.forleha/databases/db_orders");
      Directory? folderpathForDbFile = Directory("/storage/emulated/0/Android/data/com.example.forleha/files");
      await folderpathForDbFile.create();
      await savedDb.copy("/storage/emulated/0/Android/data/com.example.forleha/files");
    }catch(e){
      print('exception: $e');
    }


  }

  static Future<void> restoreDb() async {
    //статус разрешения на доступ к общему внешнему хранилищу.
    var status = await Permission.manageExternalStorage.status;
    //проверяет статус разрешения на управление внешним хранилищем.
    if(!status.isGranted){
    //Если разрешение не предоставлено, то запрашивается разрешение у пользователя
    await Permission.manageExternalStorage.request();
    }

    var status1 = await Permission.storage.status;

    if(!status1.isGranted){
      await Permission.storage.request();

    }

    try{
      File savedDb = File("/data/user/0/com.example.forleha/databases/db_orders");
      Directory? folderpathForDbFile = Directory("/storage/emulated/0/Android/data/com.example.forleha/files");
      await folderpathForDbFile.create();
      await savedDb.copy("/storage/emulated/0/Android/data/com.example.forleha/files/db_orders");
    }
    catch(e){
      print('exception: $e');
    }
  }

  static Future<void> deleteDb() async {

    try{
      deleteDatabase("/data/user/0/com.example.forleha/databases/db_orders");
    }catch(e){
      print('exception: $e');
    }

  }



  // static Future<int> updateShipmentDate(int listlLength) async {
  //   final Database db = await DatabaseManager().database;
  //
  //   for(int i = 0; i < listlLength; i++){
  //
  //     db.update(
  //       "orders",
  //       {'shipmentDate': 0,},
  //     );
  //
  //   }
  //
  //   return 6;
  // }


// void onDBUpgrade(int oldVersion, int newVersion) async {
//   final Database db = await DatabaseManager().database;
//   if (oldVersion < newVersion) {
//     await db.execute('ALTER TABLE orders ADD COLUMN shipmentDate INTEGER');
//   }
// }

// Future<void> onDBUpgrade() async {
//   final Database db = await DatabaseManager().database;
//   await db.execute(
//     "CREATE TABLE bank_tb("
//         "id INTEGER PRIMARY KEY,"
//         "admission TEXT NOT NULL,"
//         "expense TEXT NOT NULL,"
//         "admissionSum DOUBLE NOT NULL,"
//         "expenseSum DOUBLE NOT NULL,"
//         "admissionDescription TEXT NOT NULL,"
//         "expenseDescription TEXT NOT NULL,"
//         "addedAt INTEGER NOT NULL,"
//         "expAt INTEGER NOT NULL)",
//   ).then((value) {
//     print('value: --');
//   });
//
// }

}
