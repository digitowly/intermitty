import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';
import 'package:intermitty/modules/counter/counter_duration_screen.dart';
import 'package:intermitty/widgets/progress_circle.dart';

class CounterScreen extends StatelessWidget {
  final Future<String> initialTimeFuture;
  var _counterbloc;
  CounterScreen({@required this.initialTimeFuture}) {
    _counterbloc = CounterBloc(
      initialTimeFuture: initialTimeFuture,
      fastingTime: const Duration(seconds: 20),
      foodTime: const Duration(seconds: 10),
      phase: Phase.FASTING,
      running: false,
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: initialTimeFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: StreamBuilder<Object>(
                        stream: _counterbloc.timeObservable,
                        builder: (streamContext, streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            Duration duration = streamSnapshot.data;
                            return Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CustomPaint(
                                  painter: ProgressCircle(
                                      progress: duration.inSeconds / 100),
                                ),
                                CounterDurationScreen(duration: duration)
                              ],
                            );
                          } else {
                            return Stack(
                              children: [
                                CustomPaint(
                                  painter: ProgressCircle(progress: 1.9),
                                ),
                                Text(
                                  format(
                                    const Duration(
                                        hours: 0, minutes: 0, seconds: 0),
                                  ),
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            );
                          }
                        }),
                  )
                ],
              );
            } else {
              return Text('no data');
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counterbloc.toggle(),
        child: Text('start'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
