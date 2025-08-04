import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String userBoxName = 'users';
  
  // Mendaftarkan pengguna baru
  Future<bool> registerUser(String email, String password, {String? name}) async {
    try {
      // Periksa apakah userBox sudah ada
      if (!Hive.isBoxOpen(userBoxName)) {
        await Hive.openBox(userBoxName);
      }
      
      final userBox = Hive.box(userBoxName);
      
      // Periksa apakah email sudah terdaftar
      final existingUser = userBox.get(email);
      if (existingUser != null) {
        return false; // Email sudah terdaftar
      }
      
      // Buat data pengguna baru
      final userData = {
        'email': email,
        'password': password, // Dalam aplikasi nyata, gunakan enkripsi password
        'name': name ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // Simpan data pengguna dengan email sebagai key
      await userBox.put(email, userData);
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }
  
  // Login pengguna
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      if (!Hive.isBoxOpen(userBoxName)) {
        await Hive.openBox(userBoxName);
      }
      
      final userBox = Hive.box(userBoxName);
      final userData = userBox.get(email);
      
      if (userData != null && userData['password'] == password) {
        return userData;
      }
      
      return null; // Login gagal
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
  
  // Logout pengguna
  Future<void> logoutUser() async {
    // Logika logout jika diperlukan
  }
}