import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dak_cafe.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          drink_name TEXT NOT NULL,
          size TEXT NOT NULL,
          temperature TEXT NOT NULL,
          sugar_level INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price_per_item REAL NOT NULL,
          service_fee REAL NOT NULL DEFAULT 0.50,
          total REAL NOT NULL,
          customer_name TEXT NOT NULL,
          customer_phone TEXT NOT NULL,
          notes TEXT,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS reviews (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          drink_name TEXT NOT NULL,
          rating INTEGER NOT NULL,
          reviewer_name TEXT NOT NULL,
          comment TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE gift_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        purchased INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE promotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        tag TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        drink_name TEXT NOT NULL,
        size TEXT NOT NULL,
        temperature TEXT NOT NULL,
        sugar_level INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price_per_item REAL NOT NULL,
        service_fee REAL NOT NULL DEFAULT 0.50,
        total REAL NOT NULL,
        customer_name TEXT NOT NULL,
        customer_phone TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        drink_name TEXT NOT NULL,
        rating INTEGER NOT NULL,
        reviewer_name TEXT NOT NULL,
        comment TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await _seedData(db);
  }

  static Future<void> _seedData(Database db) async {
    await db.insert('users', {
      'username': 'admin',
      'password': '1234',
      'email': 'admin@dakcoffee.com',
      'name': 'Admin',
    });

    final categoryIds = <String, int>{};
    final categories = [
      'For You', 'Matcha Series', 'DAK Tea Series',
      'Buttercrème', 'Thai Milk Tea', 'Espresso',
      'Top Picks', 'CEO Series',
    ];
    for (final title in categories) {
      final id = await db.insert('categories', {'title': title});
      categoryIds[title] = id;
    }

    final products = {
      'For You': [
        {'name': 'Buttercrème Frappé', 'price': 'RM 15.20'},
        {'name': 'Iced CEO Americano', 'price': 'RM 6.90'},
        {'name': 'Iced French Vanilla Latte', 'price': 'RM 11.90'},
        {'name': 'Matcha Cloud Frappé', 'price': 'RM 15.20'},
      ],
      'Matcha Series': [
        {'name': 'Matcha Cloud Latte', 'price': 'RM 14.90'},
        {'name': 'Iced Matcha Latte', 'price': 'RM 13.90'},
        {'name': 'Matcha Frappé', 'price': 'RM 15.20'},
      ],
      'DAK Tea Series': [
        {'name': 'Jasmine Milk Tea', 'price': 'RM 9.90'},
        {'name': 'Oolong Milk Tea', 'price': 'RM 10.90'},
      ],
      'Buttercrème': [
        {'name': 'Buttercrème Frappé', 'price': 'RM 15.20'},
        {'name': 'Buttercrème Latte', 'price': 'RM 13.90'},
      ],
      'Thai Milk Tea': [
        {'name': 'Thai Milk Tea', 'price': 'RM 10.90'},
        {'name': 'Thai Milk Tea Frappé', 'price': 'RM 13.90'},
      ],
      'Espresso': [
        {'name': 'Americano', 'price': 'RM 6.90'},
        {'name': 'Flat White', 'price': 'RM 9.90'},
        {'name': 'Cappuccino', 'price': 'RM 9.90'},
      ],
      'Top Picks': [
        {'name': 'Iced CEO Americano', 'price': 'RM 6.90'},
        {'name': 'Buttercrème Frappé', 'price': 'RM 15.20'},
      ],
      'CEO Series': [
        {'name': 'CEO Americano', 'price': 'RM 6.90'},
        {'name': 'CEO Latte', 'price': 'RM 10.90'},
      ],
    };

    for (final entry in products.entries) {
      final categoryId = categoryIds[entry.key];
      if (categoryId == null) continue;
      for (final product in entry.value) {
        await db.insert('products', {
          'category_id': categoryId,
          'name': product['name'],
          'price': product['price'],
        });
      }
    }

    final giftCards = [
      {'title': 'DAK Gift Card RM 20', 'subtitle': 'Valid for 12 months from date of purchase'},
      {'title': 'DAK Gift Card RM 50', 'subtitle': 'Valid for 12 months from date of purchase'},
      {'title': 'DAK Gift Card RM 100', 'subtitle': 'Valid for 12 months from date of purchase'},
    ];
    for (final card in giftCards) {
      await db.insert('gift_cards', {'title': card['title'], 'subtitle': card['subtitle'], 'purchased': 0});
    }

    final promos = [
      {'title': 'Wednesday Special', 'description': 'Buy 2 Free 1 on all drinks every Wednesday.', 'tag': 'ONGOING'},
      {'title': 'Birthday Treat', 'description': 'Enjoy a FREE drink on your birthday month.', 'tag': 'MEMBERS'},
      {'title': 'New Member Welcome', 'description': '10% off your first order when you sign up.', 'tag': 'NEW'},
    ];
    for (final promo in promos) {
      await db.insert('promotions', {
        'title': promo['title'],
        'description': promo['description'],
        'tag': promo['tag'],
      });
    }
  }

  // ─── USER METHODS ──────────────────────────────────────────────

  static Future<bool> registerUser({
    required String username,
    required String password,
    required String name,
    required String email,
  }) async {
    try {
      final db = await database;
      await db.insert('users', {
        'username': username,
        'password': password,
        'name': name,
        'email': email,
      });
      return true;
    } catch (_) {
      return false; // username already exists (UNIQUE constraint)
    }
  }

  static Future<bool> usernameExists(String username) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateUser(int id, {String? name, String? email}) async {
    final db = await database;
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updatePassword(int id, String newPassword) async {
    final db = await database;
    return await db.update('users', {'password': newPassword},
        where: 'id = ?', whereArgs: [id]);
  }

  // ─── CATEGORY METHODS ──────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  // ─── PRODUCT METHODS ───────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId) async {
    final db = await database;
    return await db.query('products', where: 'category_id = ?', whereArgs: [categoryId]);
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT p.*, c.title AS category_title
      FROM products p
      JOIN categories c ON p.category_id = c.id
    ''');
  }

  // ─── GIFT CARD METHODS ─────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getGiftCards() async {
    final db = await database;
    return await db.query('gift_cards');
  }

  static Future<int> markGiftCardPurchased(int id) async {
    final db = await database;
    return await db.update('gift_cards', {'purchased': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  // ─── PROMOTION METHODS ─────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getPromotions() async {
    final db = await database;
    return await db.query('promotions');
  }

  // ─── ORDER METHODS ─────────────────────────────────────────────

  static Future<int> insertOrder({
    required String drinkName,
    required String size,
    required String temperature,
    required int sugarLevel,
    required int quantity,
    required double pricePerItem,
    required double total,
    required String customerName,
    required String customerPhone,
    String? notes,
  }) async {
    final db = await database;
    return await db.insert('orders', {
      'drink_name': drinkName,
      'size': size,
      'temperature': temperature,
      'sugar_level': sugarLevel,
      'quantity': quantity,
      'price_per_item': pricePerItem,
      'service_fee': 0.50,
      'total': total,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'notes': notes ?? '',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'created_at DESC');
  }

  static Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  // ─── REVIEW METHODS ────────────────────────────────────────────

  static Future<int> insertReview({
    required String drinkName,
    required int rating,
    required String reviewerName,
    required String comment,
  }) async {
    final db = await database;
    return await db.insert('reviews', {
      'drink_name': drinkName,
      'rating': rating,
      'reviewer_name': reviewerName,
      'comment': comment,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getReviews() async {
    final db = await database;
    return await db.query('reviews', orderBy: 'created_at DESC');
  }
}