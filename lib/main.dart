import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App for Doorlock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter App for Door Status'),
      debugShowCheckedModeBanner: false,
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
  final DatabaseReference _statusRef =
      FirebaseDatabase.instance.ref('door_status');
  final DatabaseReference _timestampRef =
      FirebaseDatabase.instance.ref('last_intruder_detected');
  String doorStatus = "Loading...";
  String intruderTimeStamp = '';
  @override
  void initState() {
    super.initState();
    _statusRef.onValue.listen((DatabaseEvent event) {
      final status = event.snapshot.value;
      setState(() {
        // print(event.snapshot);
        // print(status);
        doorStatus = status.toString();
      });
    });

    _timestampRef.onValue.listen((DatabaseEvent event) {
      final stamp = event.snapshot.value;
      setState(() {
        if (stamp is double) {
          DateTime timeStamp =
              DateTime.fromMillisecondsSinceEpoch((stamp * 1000).round());
          intruderTimeStamp =
              DateFormat('yyyy-MM-dd hh:mm:ss a').format(timeStamp.toLocal());
        }
      });
      // print(intruderTimeStamp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  doorStatus == 'locked' ? Icons.lock : Icons.lock_open,
                  key: ValueKey(doorStatus),
                  color: doorStatus == 'locked' ? Colors.red : Colors.green,
                  size: 220,
                ),
              ),
              const Text(
                'Current Door Status:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                doorStatus[0].toUpperCase() + doorStatus.substring(1),
                style: TextStyle(
                    color: doorStatus == 'locked' ? Colors.red : Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Last Intruder Alert:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                intruderTimeStamp,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
