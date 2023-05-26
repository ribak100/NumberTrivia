import 'package:flutter/material.dart';
import 'package:trivianumbers/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:trivianumbers/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green[800],
        accentColor: Colors.green[600],
      ),
      home: const NumberTriviaPage(),
    );
  }
}
