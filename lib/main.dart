import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'beranda_page.dart';
import 'kuis_page.dart';
import 'video_page.dart';
import 'settings_page.dart';
import 'akun_page.dart'; // Pastikan file ini diimpor

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Hive
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Venture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(), // Tambahkan route /login juga
        '/register': (context) => const RegisterPage(),
        '/beranda': (context) => const BerandaPage(),
        '/kuis': (context) => const KuisPage(),
        '/settings': (context) => const SettingsPage(),
        '/video': (context) => const VideoPage(),
        '/akun': (context) => const AkunPage(), // Tambahkan route untuk halaman akun
      },
      // Tambahkan ini untuk memudahkan debugging navigasi
      navigatorObservers: [
        MyNavigatorObserver(), // Observer untuk debug navigasi
      ],
    );
  }
}

// Class ini membantu untuk debug navigasi
class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigasi: Pushed ${route.settings.name} from ${previousRoute?.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigasi: Popped ${route.settings.name} to ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigasi: Removed ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('Navigasi: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}