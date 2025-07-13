import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallet/models/card_provider.dart';
import 'package:wallet/pages/main_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://sawzxembmwabtxeedmya.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhd3p4ZW1ibXdhYnR4ZWVkbXlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIzMjczMDMsImV4cCI6MjA2NzkwMzMwM30.jZJi2AmTHzfTPJsAcmOpQgjDpA-kX7_5gUW0HUx2Jd0',
  );
  final supabase = Supabase.instance.client;
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.openBox('cardsBox');
  runApp(
    ChangeNotifierProvider(create: (_) => CardProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const MyMainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
