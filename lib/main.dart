import 'package:flutter/material.dart';
import 'package:cookly_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //load .env
  await dotenv.load(fileName: ".env");

  //initialize supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
  runApp(const MyApp());
  print('ENV Loaded: ${dotenv.env.isNotEmpty}');
  print('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
  print('SUPABASE_URL: ${dotenv.env['SUPABASE_KEY']}');
}
