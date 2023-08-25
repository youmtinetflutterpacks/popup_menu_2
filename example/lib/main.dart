import 'package:flutter/material.dart';
import 'package:popup_menu_2/contextual_menu.dart';
import 'package:popup_menu_2/popup_menu_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.white),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;
  GlobalKey key = GlobalKey();

  void _incrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('awaited successfully');

    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('awaited successfully');
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: AppBar(
            actions: [
              PhysicalModel(
                color: Colors.grey,
                shape: BoxShape.circle,
                elevation: 10,
                child: add(context),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                _counter.toStringAsFixed(3),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget add(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ContextualMenu(
        targetWidgetKey: key,
        ctx: context,
        maxColumns: 1,
        backgroundColor: Colors.red,
        highlightColor: Colors.white,
        onDismiss: () {
          setState(() {
            _counter = _counter * 1.2;
          });
        },
        items: [
          CustomPopupMenuItem(
            press: _incrementCounter,
            title: 'increment',
            textAlign: TextAlign.justify,
            textStyle: const TextStyle(color: Colors.white),
            image: const Icon(Icons.add, color: Colors.white),
          ),
          CustomPopupMenuItem(
            press: _decrementCounter,
            title: 'decrement',
            textAlign: TextAlign.justify,
            textStyle: const TextStyle(color: Colors.white),
            image: const Icon(Icons.remove, color: Colors.white),
          ),
        ],
        child: Icon(
          Icons.add,
          key: key,
          color: Colors.white,
        ),
      ),
    );
  }
}
