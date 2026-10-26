import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';
import '../models/transaction_model.dart';

class EmailAlreadyUsedException implements Exception {
  @override
  String toString() => 'Email sudah terdaftar';
}

/// Penyimpanan lokal (SQLite) untuk akun pengguna dan transaksi.
class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            amount INTEGER NOT NULL,
            is_income INTEGER NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  //  AUTH
  /// Mendaftarkan pengguna baru. Melempar [EmailAlreadyUsedException]
  /// bila email sudah dipakai. Mengembalikan pengguna yang baru dibuat.
  Future<AppUser> register(String name, String email, String password) async {
    final db = await database;
    final cleanEmail = email.trim().toLowerCase();

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [cleanEmail],
      limit: 1,
    );
    if (existing.isNotEmpty) throw EmailAlreadyUsedException();

    final id = await db.insert('users', {
      'name': name.trim(),
      'email': cleanEmail,
      'password_hash': _hash(password),
      'created_at': DateTime.now().toIso8601String(),
    });

    return AppUser(id: id, name: name.trim(), email: cleanEmail);
  }

  /// Mengembalikan pengguna bila email & password cocok, selain itu null.
  Future<AppUser?> login(String email, String password) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email.trim().toLowerCase(), _hash(password)],
      limit: 1,
    );
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }

  Future<AppUser?> getUserById(int id) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }

  // TRANSAKSI

  Future<int> insertTransaction(TransactionModel t) async {
    final db = await database;
    return db.insert('transactions', t.toMap());
  }

  Future<List<TransactionModel>> getTransactions(int userId) async {
    final db = await database;
    final rows = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(TransactionModel.fromMap).toList();
  }
}
