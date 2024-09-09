
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import 'package:examflutterdart/config/database_helper.dart';
import 'package:examflutterdart/models/order.dart';

class AppOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm đơn hàng mới vào SQLite và Firestore
  Future<void> insertAppOrder(AppOrder order) async {
    final db = await DatabaseHelper().database;

    // Thêm đơn hàng vào SQLite
    await db.insert(
      'orders',  // Đảm bảo tên bảng là 'orders' như đã tạo trước đó
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Thêm đơn hàng vào Firestore
    await _firestore.collection('orders').doc(order.id.toString()).set(order.toMap());
  }

  // Cập nhật thông tin đơn hàng trong SQLite và Firestore
  Future<void> updateAppOrder(AppOrder order) async {
    final db = await DatabaseHelper().database;

    // Cập nhật đơn hàng trong SQLite
    await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );

    // Cập nhật đơn hàng trong Firestore
    await _firestore.collection('orders').doc(order.id.toString()).update(order.toMap());
  }

  // Xóa đơn hàng khỏi SQLite và Firestore
  Future<void> deleteAppOrder(int id) async {
    final db = await DatabaseHelper().database;

    try {
      // Xóa đơn hàng khỏi SQLite
      await db.delete(
        'orders',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Đơn hàng với ID $id đã được xóa khỏi SQLite.');

      // Xóa đơn hàng khỏi Firestore
      final docRef = _firestore.collection('orders').doc(id.toString());
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
        print('Đơn hàng với ID $id đã được xóa khỏi Firestore.');
      } else {
        print('Đơn hàng với ID $id không tồn tại trong Firestore.');
      }
    } catch (e) {
      print('Lỗi khi xóa đơn hàng với ID $id: $e');
    }
  }

  // Lấy danh sách tất cả đơn hàng từ SQLite
  Future<List<AppOrder>> getAppOrders() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    // Trả về danh sách đơn hàng từ SQLite
    return List.generate(maps.length, (i) {
      return AppOrder.fromMap(maps[i]);
    });
  }

  // Lấy thông tin đơn hàng theo ID từ SQLite (nếu không tìm thấy sẽ kiểm tra Firestore)
  Future<AppOrder?> getAppOrderById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AppOrder.fromMap(maps.first);
    } else {
      // Nếu không có đơn hàng trong SQLite, kiểm tra Firestore
      final doc = await _firestore.collection('orders').doc(id.toString()).get();
      if (doc.exists) {
        final order = AppOrder.fromMap(doc.data()!);
        // Cập nhật đơn hàng vào SQLite nếu chưa có
        await db.insert(
          'orders',
          order.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return order;
      } else {
        return null;
      }
    }
  }
}