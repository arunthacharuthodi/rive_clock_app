import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? timeNow;
  late StateMachineController _controller;
  bool isactive = false;

  SMIInput<SMITrigger>? _trigger1; // Declare trigger for click action 1
  SMIInput<SMITrigger>? _trigger2; // Declare trigger for click action 2
  SMIInput<bool>?
      _currentState; // Track the current state input (for checking active state)
  SMIBool? isNight;
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);

      // Assign the triggers by their names as defined in Rive
      _trigger1 = controller.findSMI('day'); // Click action 1
      isNight = controller.findSMI('day'); // Click action 2

      // Example of tracking a boolean input to know which state is active
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          timeNow = DateFormat('hh:mm a').format(DateTime.now());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xffFFAA37),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 450,
              child: Center(
                  child: RiveAnimation.asset("assets/cat.riv",
                      stateMachines: ['State Machine 1'],
                      fit: BoxFit.contain,
                      onInit: _onRiveInit)),
            ),
            SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Color.fromARGB(255, 255, 194, 108),
                    ),
                    onPressed: () {
                      setState(() {
                        isNight?.value = !isactive;
                        isactive = !isactive;
                      });
                    },
                    child: Text(
                      timeNow ?? "NONE",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff262626)),
                    ))),
          ],
        ),
      ),
    );
  }
}
