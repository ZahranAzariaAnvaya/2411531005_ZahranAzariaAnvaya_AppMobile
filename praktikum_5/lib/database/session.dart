import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'db_helper.dart';

/// Menyimpan pengguna yang sedang login.
/// - [user] dibaca oleh semua halaman.
/// - id pengguna disimpan di shared_preferences agar tidak perlu login ulang.
class Session {
  static const _key = 'logged_in_user_id';

  static AppUser? user;

  /// Dipanggil saat aplikasi dibuka untuk memulihkan sesi tersimpan.
  static Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt(_key);
      user = id == null ? null : await DbHelper.instance.getUserById(id);
    } catch (_) {
      user = null;
    }
  }

  static Future<void> login(AppUser u) async {
    user = u;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, u.id);
  }

  static Future<void> logout() async {
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
