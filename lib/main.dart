import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lab_11/firebase_options.dart';
import 'package:lab_11/pages/home_page.dart';
import 'package:lab_11/pages/login_page.dart';
import 'package:lab_11/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // โหลดค่า .env

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';

  // ✅ ตั้งค่า Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MyAuthProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe Review',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 21, 209, 234),
        ),
      ),
      home: Consumer<MyAuthProvider>(
        builder: (context, auth, _) {
          return auth.user == null ? LoginPage() : HomePage();
        },
      ),
    );
  }
}
