import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../constants.dart';

class CountDownTimer extends StatefulWidget {
  final timeFromData;
  const CountDownTimer({
    this.timeFromData,
  });

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      widgetBuilder: (_, time) {
        if (time == null) {
          return Material(
              elevation: 10.0,
              color: Colors.red,
              borderRadius: BorderRadius.circular(20.0),
              child: Center(
                child: Text('Time Finsh', style: kCountFinsh),
              ));
        }

        List<Widget> list = []
          ..add(time.days != null ? makeTime(time.days, 'days') : null)
          ..add(time.days != null ? Text(':', style: kTimeDot) : null)
          ..add(time.hours != null ? makeTime(time.hours, 'hours') : null)
          ..add(time.hours != null ? Text(':', style: kTimeDot) : null)
          ..add(time.min != null ? makeTime(time.min, 'min') : null)
          ..add(time.min != null ? Text(':', style: kTimeDot) : null)
          ..add(time.sec != null ? makeTime(time.sec, 'sec') : null);

        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.transparent,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset:
                          Offset(-5.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Text(
                  widget.timeFromData.startOrEnd() ? 'Start IN' : 'End IN',
                  style: kTimeNumber,
                ),
              ), // child widget, replace with your own
              const SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: list..removeWhere((value) => value == null))
            ]);
      },
      onEnd: () {
        setState(() {});
      },
      endTime: widget.timeFromData.startOrEnd()
          ? widget.timeFromData.start.millisecondsSinceEpoch
          : widget.timeFromData.end.millisecondsSinceEpoch,
    );
  }

  Column makeTime(int time, text) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
          boxShadow: [KBoxShadowTime],
        ),
        child: Text(
          '$time',
          style: kTimeDot,
        ),
      ),
      Text(
        '$text',
        style: KTimeText,
      ),
    ]);
  }
}
