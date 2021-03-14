import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_screen.dart';
import 'package:intermitty/widgets/stateful_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Future<String> loadTimeData() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('time'));
    return prefs.getString('time');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StatefulWrapper(
        onInit: () {
          print('Init');
          loadTimeData();
        },
        child: CounterScreen(
          initialTimeFuture: loadTimeData(),
        ),
      ),
    );
  }
}
