import 'package:flutter/material.dart';
import 'package:intermitty/modules/counter/counter_bloc.dart';
import 'package:intermitty/modules/counter/counter_duration_screen.dart';
import 'package:intermitty/widgets/progress_circle.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class CounterScreen extends StatelessWidget {
  final Future<String> initialTimeFuture;

  CounterScreen({@required this.initialTimeFuture});

  void setup() {
    getIt.registerSingleton<CounterBloc>(CounterBloc(
      initialTimeFuture: initialTimeFuture,
      fastingTime: const Duration(minutes: 1),
      foodTime: const Duration(seconds: 10),
      initPhase: Phase.FASTING,
      running: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    setup();

    final _counter = getIt.get<CounterBloc>();
    return Scaffold(
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
                        stream: _counter.stream,
                        builder: (streamContext, streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            CounterState counterState = streamSnapshot.data;
                            return Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CustomPaint(
                                  painter: ProgressCircle(
                                      progress: counterState.circleValue),
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
        onPressed: () => _counter.run(),
        child: Text('start'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
