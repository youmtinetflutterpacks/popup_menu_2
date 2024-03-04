import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_2.dart';

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
      theme: ThemeData(primarySwatch: Colors.brown, primaryColor: Colors.white),
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
  int _counter = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ContextualMenuState> keyState = GlobalKey<ContextualMenuState>();

  Future<void> _incrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _counter++;
    });

    keyState.currentState?.dismiss();
  }

  Future<void> _decrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _counter--;
    });
    keyState.currentState?.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          //   leading: _action(context),
          bottom: AppBar(
            actions: [_action(context)],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'The Accountant result',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PhysicalModel _action(BuildContext context) {
    return PhysicalModel(
      color: Colors.grey,
      shape: BoxShape.circle,
      elevation: 10,
      child: SizedBox(
        height: AppBar().preferredSize.height,
        width: AppBar().preferredSize.height,
        child: add(context),
      ),
    );
  }

  Widget add(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ContextualMenu(
        key: keyState,
        targetWidgetKey: key,
        maxColumns: 2,
        backgroundColor: Colors.red,
        dismissOnClickAway: true,
        items: [
          ContextPopupMenuItem(
            onTap: _incrementCounter,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          ContextPopupMenuItem(
            onTap: _decrementCounter,
            child: const Icon(Icons.remove, color: Colors.white),
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
