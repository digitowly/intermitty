import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';
import 'package:intermitty/widgets/progress_circle.dart';

class CounterScreen extends StatelessWidget {
  final _counterbloc = CounterBloc(
    initialTime: DateTime.now(),
    fastingTime: const Duration(seconds: 20),
    running: false,
  );

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
                    return Column(
                      children: [
                        CustomPaint(
                          painter: ProgressCircle(progress: 1.9),
                        ),
                        Text(
                          format(duration),
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        CustomPaint(
                          painter: ProgressCircle(progress: 1.9),
                        ),
                        Text(
                          format(
                            const Duration(hours: 0, minutes: 0, seconds: 0),
                          ),
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
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
