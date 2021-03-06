import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';

class CounterScreen extends StatelessWidget {
  final _counterbloc = CounterBloc(initialTime: 10, running: false);

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
                  return Text(
                    snapshot.data.toString(),
                  );
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
