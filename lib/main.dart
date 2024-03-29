import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:odessa/responsive/responsive_ui.dart';
import 'package:odessa/service/service.dart';
import 'data/datahelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerAdp();
  await Hive.initFlutter();
  await openBox();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Odessa',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffFF5959),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor:  Color(0xffFF5959) 
           //here you can give the text color
            ),
      
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

void registerAdp() {
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(FavoriteAdapter());
}

Future openBox() async {
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Favorite>('favorite');
}
