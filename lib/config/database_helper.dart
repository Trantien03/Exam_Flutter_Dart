import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'databasebackup.db');

    final file = File(path);
    if (!await file.exists()) {
      await _copyDatabaseFromAssets(path);
    }

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    // Dọn dẹp dữ liệu cũ trong SQLite
    await _clearDatabase(db);

    // Tải và lưu dữ liệu mới từ Firebase
    await _fetchAndInsertOrdersFromFirebase(db);

    return db;
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    final data = await rootBundle.load('assets/order_database.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tạo bảng 'orders' để lưu thông tin đơn hàng
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dishName TEXT,
        votes INTEGER,
        note TEXT,
        quantity INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Cập nhật database nếu cần
    }
  }

  Future<void> _clearDatabase(Database db) async {
    // Xóa tất cả dữ liệu cũ từ bảng 'orders'
    await db.delete('orders');
    print('Dữ liệu cũ đã bị xóa.');
  }

  Future<void> _fetchAndInsertOrdersFromFirebase(Database db) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Lấy dữ liệu từ Firestore (collection 'orders')
    QuerySnapshot querySnapshot = await firestore.collection('orders').get();

    // Lưu dữ liệu vào SQLite
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      await db.insert('orders', {
        'dishName': data['dishName'],
        'votes': data['votes'],
        'note': data['note'],
        'quantity': data['quantity'],
      });
    }
    print('Dữ liệu đơn hàng đã được tải từ Firebase và lưu vào SQLite.');
  }

  // Hàm để thêm đơn hàng mới vào Firebase và SQLite
  Future<void> addOrder(String dishName, int votes, String note, int quantity) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final db = await database;

    // Thêm vào Firestore
    DocumentReference docRef = await firestore.collection('orders').add({
      'dishName': dishName,
      'votes': votes,
      'note': note,
      'quantity': quantity,
    });

    // Thêm vào SQLite
    await db.insert('orders', {
      'dishName': dishName,
      'votes': votes,
      'note': note,
      'quantity': quantity,
    });

    print('Đơn hàng đã được thêm vào Firebase và SQLite.');
  }

  // Hàm để lấy danh sách đơn hàng từ SQLite
  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders');
  }
}