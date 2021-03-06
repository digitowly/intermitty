import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CounterScreen());
  }
}
