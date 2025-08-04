import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'music_background.dart';
import 'login_page.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan error via snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Validasi secara manual sebelum mengirim request
  bool _validateInputs() {
    // Reset error state
    bool isValid = true;
    
    // Validasi nama
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackbar('Nama tidak boleh kosong');
      isValid = false;
    }
    
    // Validasi email
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackbar('Email tidak boleh kosong');
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      _showErrorSnackbar('Email tidak valid');
      isValid = false;
    }
    
    // Validasi password
    if (_passwordController.text.isEmpty) {
      _showErrorSnackbar('Password tidak boleh kosong');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      _showErrorSnackbar('Password minimal 6 karakter');
      isValid = false;
    }
    
    return isValid;
  }

  // Fungsi untuk menyimpan data user ke SharedPreferences
  Future<void> _saveUserToPrefs(String name, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);
      await prefs.setString('accountType', 'Free');
      await prefs.setBool('isLoggedIn', true);
      
      print('Data user disimpan ke SharedPreferences: $name, $email');
    } catch (e) {
      print('Error menyimpan data user ke SharedPreferences: $e');
    }
  }

  Future<void> _register() async {
    // Validasi input secara manual
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      print('Mencoba mendaftarkan: $name, $email'); // Debug log

      final success = await _authService.registerUser(email, password, name: name);

      if (success) {
        print('Pendaftaran berhasil!'); // Debug log
        
        // Simpan data user ke SharedPreferences untuk ditampilkan di akun_page.dart
        await _saveUserToPrefs(name, email);
        
        // Tampilkan snackbar sukses sebelum pindah halaman
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pendaftaran berhasil! Silakan login.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Delay sedikit untuk memungkinkan snackbar terlihat
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          });
        }
      } else {
        print('Pendaftaran gagal: email sudah terdaftar'); // Debug log
        if (mounted) {
          _showErrorSnackbar('Email sudah terdaftar');
        }
      }
    } catch (e) {
      print('Error saat pendaftaran: $e'); // Debug log
      if (mounted) {
        _showErrorSnackbar('Terjadi kesalahan: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MusicBackground(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 10
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Daftar Akun Anda',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Form nama
                Container(
                  width: size.width * 0.55,
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan Nama Anda',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      border: InputBorder.none,
                      errorStyle: TextStyle(height: 0, color: Colors.transparent),
                    ),
                    // Menghilangkan validator built-in karena kita menggunakan validasi manual
                  ),
                ),
                
                // Form email
                Container(
                  width: size.width * 0.55,
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan Email',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      border: InputBorder.none,
                      errorStyle: TextStyle(height: 0, color: Colors.transparent),
                    ),
                    // Menghilangkan validator built-in karena kita menggunakan validasi manual
                  ),
                ),
                
                // Form password
                Container(
                  width: size.width * 0.55,
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Kata Sandi',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      border: InputBorder.none,
                      errorStyle: TextStyle(height: 0, color: Colors.transparent),
                    ),
                    // Menghilangkan validator built-in karena kita menggunakan validasi manual
                  ),
                ),
                
                // Tombol Daftar
                Container(
                  width: size.width * 0.55,
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register, // Ini panggilan ke fungsi _register
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE67E42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                // Link Login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(10, 10),
                  ),
                  child: const Text(
                    'Sudah memiliki akun? Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}