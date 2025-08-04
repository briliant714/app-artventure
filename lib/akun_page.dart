import 'package:flutter/material.dart';
import 'music_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String _userName = '';
  String _email = '';
  String? _profileImagePath;
  bool _isLoading = true;
  bool _isHovering = false;
  
  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }
  
  Future<void> _loadAccountInfo() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedIn) {
        setState(() {
          _userName = prefs.getString('userName') ?? 'User';
          _email = prefs.getString('userEmail') ?? '';
          _profileImagePath = prefs.getString('profileImagePath');
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = 'Guest';
          _email = 'example@gmail.com';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading account info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveAccountInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _userName);
      await prefs.setString('userEmail', _email);
      if (_profileImagePath != null) {
        await prefs.setString('profileImagePath', _profileImagePath!);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account information updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving account info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update account information'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;
        
        if (filePath != null) {
          setState(() {
            _profileImagePath = filePath;
          });
          
          await _saveAccountInfo();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gambar profil berhasil diperbarui'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error memilih gambar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih gambar'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _email);
    
    // Get screen size to ensure responsiveness
    final screenSize = MediaQuery.of(context).size;
    
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.deepPurple.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // Set maximum width and height based on screen size
        child: Container(
          width: screenSize.width * 0.8,
          constraints: BoxConstraints(
            maxHeight: screenSize.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 16),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEF8B60)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEF8B60)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Auto-layout the buttons based on screen width
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.maxWidth < 250
                          ? Column(
                              children: [
                                _buildCancelButton(context),
                                const SizedBox(height: 8),
                                _buildSaveButton(context, nameController, emailController),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildCancelButton(context),
                                const SizedBox(width: 8),
                                _buildSaveButton(context, nameController, emailController),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper methods for buttons to reduce duplicate code
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
  
  Widget _buildSaveButton(BuildContext context, TextEditingController nameController, TextEditingController emailController) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF8B60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {
        setState(() {
          _userName = nameController.text;
          _email = emailController.text;
        });
        _saveAccountInfo();
        Navigator.of(context).pop();
      },
      child: const Text(
        'Save',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
  
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      
      // Perbaikan untuk navigasi
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      print('Error during logout: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saat logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: MusicBackground(
          child: Center(
            child: CircularProgressIndicator(
              color: const Color(0xFFEF8B60),
            ),
          ),
        ),
      );
    }
    
    // Dapatkan ukuran layar
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: MusicBackground(
        child: SafeArea(
          // Gunakan SafeArea untuk menghindari overflow pada area notch dan bottom bar
          child: Column(
            children: [
              // Back button
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              
              // Gunakan Expanded untuk bagian tengah
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile information di tengah
                    Column(
                      children: [
                        // Profile image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple.shade800.withOpacity(0.3),
                            border: Border.all(
                              color: const Color(0xFFEF8B60),
                              width: 2,
                            ),
                          ),
                          child: MouseRegion(
                            onEnter: (_) => setState(() => _isHovering = true),
                            onExit: (_) => setState(() => _isHovering = false),
                            child: Stack(
                              children: [
                                // Profile image
                                Center(
                                  child: _profileImagePath != null
                                      ? ClipOval(
                                          child: _profileImagePath!.startsWith('assets/')
                                              ? Image.asset(
                                                  _profileImagePath!,
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                )
                                              : Image.file(
                                                  File(_profileImagePath!),
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.person,
                                                      color: Color(0xFFEF8B60),
                                                      size: 40,
                                                    );
                                                  },
                                                ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Color(0xFFEF8B60),
                                          size: 40,
                                        ),
                                ),
                                
                                // Edit icon overlay on hover
                                if (_isHovering)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Username
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Email
                        Text(
                          _email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        
                        // Menghapus badge account type dan spacing setelah email
                      ],
                    ),
                    
                    // Bottom buttons - dalam Expanded sehingga tidak akan overflow
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Profile button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade800.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.cyan.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                _showEditProfileDialog();
                              },
                              borderRadius: BorderRadius.circular(18),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: const Color(0xFFEF8B60),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 14),
                          
                          // Logout button centered
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                _showLogoutConfirmation(context);
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.red.shade300,
                                size: 18,
                              ),
                              label: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red.shade300,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Padding tambahan di bawah untuk mencegah overflow
              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade900,
        title: const Text(
          'Logout Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF8B60),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}