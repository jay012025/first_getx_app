import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'views/login_screen.dart';
import 'views/users_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AES key must be 16 characters
  await EncryptedSharedPreferences.initialize("1234567890abcdef");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick & Morty GetX App',
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(name: "/users", page: () => const UsersListScreen()),
      ],
    );
  }
}
