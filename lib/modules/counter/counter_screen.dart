import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';
import 'package:intermitty/modules/counter/counter_duration_screen.dart';
import 'package:intermitty/utils/helpers/normalize.dart';
import 'package:intermitty/widgets/progress_circle.dart';

class CounterScreen extends StatelessWidget {
  final Future<String> initialTimeFuture;
  var _counterbloc;
  CounterScreen({@required this.initialTimeFuture}) {
    _counterbloc = CounterBloc(
      initialTimeFuture: initialTimeFuture,
      fastingTime: const Duration(seconds: 20),
      foodTime: const Duration(seconds: 10),
      initPhase: Phase.FASTING,
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
                            CounterState counterState = streamSnapshot.data;
                            Duration duration = counterState.duration;
                            var maxVal = 0.0;
                            var circleValue = 0.0;
                            if (duration != null) {
                              maxVal = counterState.phase == Phase.EATING
                                  ? const Duration(seconds: 10)
                                      .inSeconds
                                      .toDouble()
                                  : const Duration(seconds: 20)
                                      .inSeconds
                                      .toDouble();
                              circleValue =
                                  Normalize(maxValue: maxVal, minValue: 0.0)
                                      .forCircle(counterState.duration.inSeconds
                                          .toDouble());
                            }
                            return Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CustomPaint(
                                  painter:
                                      ProgressCircle(progress: circleValue),
                                ),
                                CounterDurationScreen(
                                    duration: counterState.duration)
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
