import 'package:flutter/material.dart';
import 'package:cookly_app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger('your_package_name');

  //load .env
  await dotenv.load(fileName: ".env");

  //initialize supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
  runApp(const MyApp());
  logger.info('ENV Loaded: ${dotenv.env.isNotEmpty}');
  logger.info('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
  logger.info('SUPABASE_KEY: ${dotenv.env['SUPABASE_KEY']}');
}
