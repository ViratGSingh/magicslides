import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/ppt_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  print(
      'Main: Loaded Supabase URL: ${supabaseUrl.isNotEmpty ? "Found" : "Missing"}');
  if (supabaseUrl.isNotEmpty) {
    print('Main: URL starts with: ${supabaseUrl.substring(0, 10)}...');
  }
  print(
      'Main: Loaded Supabase Key: ${supabaseKey.isNotEmpty ? "Found" : "Missing"}');

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  print('Main: Supabase initialized');

  final user = Supabase.instance.client.auth.currentUser;
  final initialRoute = user != null ? '/home' : '/login';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthViewModel()..checkCurrentUser()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PptViewModel()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
