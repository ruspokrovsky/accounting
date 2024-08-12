import 'package:flutter/material.dart';
import 'package:forleha/navigation.dart';
import 'package:forleha/routers.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Органайзер'),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSplash = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: Image.asset('assets/images/lexus.jpg'),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black87,
          ),
          Positioned(
            left: 26.0,
            top: 36.0,
            child:
            GestureDetector(
              onLongPress: () async {
                await Navigation().navigateToHomePage(context).then((value) {
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.transparent,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
