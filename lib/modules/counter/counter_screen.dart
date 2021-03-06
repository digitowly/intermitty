import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';

class CounterScreen extends StatelessWidget {
  final _counterbloc = CounterBloc(initialTime: DateTime.now(), running: false);
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: StreamBuilder<Object>(
                stream: _counterbloc.timeObservable,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Duration duration = snapshot.data;
                    return Text(
                      format(duration),
                      style: TextStyle(fontSize: 30),
                    );
                  } else {
                    return Text(
                      format(
                        const Duration(hours: 0, minutes: 0, seconds: 0),
                      ),
                      style: TextStyle(fontSize: 30),
                    );
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counterbloc.toggle(),
        child: Text('start'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
