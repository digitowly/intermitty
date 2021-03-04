import 'package:flutter/material.dart';
import 'package:intermitty/modules/timer/bloc/timer_bloc.dart';

class TimerScreen extends StatelessWidget {
  final _timerbloc = TimerBloc(initialTime: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: StreamBuilder<Object>(
                stream: _timerbloc.timeObservable,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _timerbloc.increment(),
        child: Text('start'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
