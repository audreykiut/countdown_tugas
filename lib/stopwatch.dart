import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stopwatch_tugas/rounded_button.dart';

class CountDownTimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => CountDownTimerPage(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<CountDownTimerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _isHours = true;
  int valHours = 0;
  int valMinute = 0;
  int valSecond = 0;
  int valh = 0;
  int valm = 0;
  int vals = 0;
  bool showNotif = false;
  bool startTime = false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
  );

  @override
  void initState() {
    super.initState();

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Timer'),
        backgroundColor: Colors.red[400],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: startTime == true,
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value,
                          hours: _isHours, milliSecond: true);

                      if (displayTime == "00:00:00.00") {
                        flutterLocalNotificationsPlugin.show(
                          0,
                          'Stopwatch Ended',
                          'The stopwatch is Ended',
                          // Schedule a notification every minute
                          NotificationDetails(
                            android: AndroidNotificationDetails(
                              'channel_id',
                              'channel_name',
                              importance: Importance.high,
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: startTime == false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Hour",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          NumberPicker(
                            minValue: 0,
                            maxValue: 24,
                            value: valHours,
                            onChanged: (value) => setState(() {
                              valHours = value;

                              valh = valHours * 3600;

                              int x = valh + valm + vals;

                              _stopWatchTimer.setPresetSecondTime(x,
                                  add: false);
                            }),
                            zeroPad: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Minute",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          NumberPicker(
                            minValue: 0,
                            maxValue: 60,
                            value: valMinute,
                            onChanged: (value) => setState(() {
                              valMinute = value;

                              valm = valMinute * 60;
                              int x = valh + valm + vals;
                              _stopWatchTimer.setPresetSecondTime(x,
                                  add: false);
                            }),
                            zeroPad: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Second",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          NumberPicker(
                            minValue: 0,
                            maxValue: 60,
                            value: valSecond,
                            onChanged: (value) => setState(() {
                              valSecond = value;
                              vals = valSecond * 1;
                              int x = valh + valm + vals;
                              _stopWatchTimer.setPresetSecondTime(x,
                                  add: false);
                            }),
                            zeroPad: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 170,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RoundedButton(
                            color: Colors.lightBlue,
                            onTap: () {
                              _stopWatchTimer.onStartTimer();

                              setState(() {
                                startTime = true;
                              });
                            },
                            child: const Text(
                              'Start',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RoundedButton(
                            color: Colors.green,
                            onTap: () {
                              _stopWatchTimer.onStopTimer();
                            },
                            child: const Text(
                              'Stop',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: RoundedButton(
                            color: Colors.red,
                            onTap: () {
                              _stopWatchTimer.onResetTimer();
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 4),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Flexible(
                //         child: Padding(
                //           padding: const EdgeInsets.all(0).copyWith(right: 8),
                //           child: RoundedButton(
                //             color: Colors.deepPurpleAccent,
                //             onTap: _stopWatchTimer.onAddLap,
                //             child: const Text(
                //               'Lap',
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 4),
                //   child: RoundedButton(
                //     color: Colors.pinkAccent,
                //     onTap: () {
                //       _stopWatchTimer.setPresetSecondTime(10);
                //     },
                //     child: const Text(
                //       'Tested',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Flexible(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: RoundedButton(
                //           color: Colors.pinkAccent,
                //           onTap: () {
                //             _stopWatchTimer.setPresetHoursTime(1);
                //           },
                //           child: const Text(
                //             'Set Hours',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Flexible(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: RoundedButton(
                //           color: Colors.pinkAccent,
                //           onTap: () {
                //             _stopWatchTimer.setPresetMinuteTime(60);
                //           },
                //           child: const Text(
                //             'Set Minute',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Flexible(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: RoundedButton(
                //           color: Colors.pinkAccent,
                //           onTap: () {
                //             _stopWatchTimer.setPresetSecondTime(10);
                //           },
                //           child: const Text(
                //             'Set +Second',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Flexible(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: RoundedButton(
                //           color: Colors.pinkAccent,
                //           onTap: () {
                //             _stopWatchTimer.setPresetSecondTime(-10);
                //           },
                //           child: const Text(
                //             'Set -Second',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RoundedButton(
                    color: Colors.pinkAccent,
                    onTap: () {
                      _stopWatchTimer.clearPresetTime();

                      setState(() {
                        startTime = false;
                        valHours = 0;
                        valMinute = 0;
                        valSecond = 0;
                        valh = 0;
                        vals = 0;
                        valm = 0;
                      });
                      flutterLocalNotificationsPlugin.show(
                        0,
                        'Stopwatch Clear and Ended',
                        'The stopwatch is Ended',
                        // Schedule a notification every minute
                        NotificationDetails(
                          android: AndroidNotificationDetails(
                            'channel_id',
                            'channel_name',
                            importance: Importance.high,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Clear PresetTime & End',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
