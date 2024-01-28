import 'package:flutter/material.dart';
import 'package:flutter_daylight_savings/flutter_daylight_savings.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daylight Savings Transitions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DstTransition>? transitions;
  String errorMessage = '';

  void getTransitions() async {
    try {
      List<DstTransition> result = await FlutterDaylightSavings.getNextTransitions(count: 50);
      setState(() {
        transitions = result;
        errorMessage = '';
      });
    } catch (e, stacktrace) {
      setState(() {
        errorMessage = e.toString() + '\n' + stacktrace.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daylight Savings Transitions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: getTransitions,
              child: Text('Get Transitions'),
            ),
            if (transitions != null)
              Text('Found ${transitions!.length} transitions'),
            if (transitions != null)
              Expanded(
                child: ListView.builder(
                  itemCount: transitions!.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(transitions![index].timestamp * 1000);
                    String dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                    return ListTile(
                      title: Text('Timestamp: ${transitions![index].timestamp} ($dateStr)'),
                      subtitle: Text('Offset: ${transitions![index].offset}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
