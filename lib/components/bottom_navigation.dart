import 'package:flutter/material.dart';

import 'bottom_icon_button.dart';
import 'custom_painter.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    @required this.size,
    @required this.currentIndex,
    @required this.onPressedFloat,
    @required this.onPressedicon0,
    @required this.onPressedicon1,
    @required this.onPressedicon2,
    @required this.onPressedicon3,
  });

  final Size size;
  final int currentIndex;
  final Function onPressedFloat;
  final Function onPressedicon0;
  final Function onPressedicon1;
  final Function onPressedicon2;
  final Function onPressedicon3;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: size.width,
      height: 80,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, 80),
            painter: BNBCustomPainter(),
          ),
          Center(
              heightFactor: 0.6,
              child: ElevatedButton(
                  child: Icon(
                    Icons.arrow_upward_outlined,
                    size: 50.0,
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                      shape: MaterialStateProperty.all<CircleBorder>(
                          CircleBorder(
                              side: BorderSide(color: Colors.blueGrey)))),
                  onPressed: onPressedFloat)),
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomIcon(
                  index: 0,
                  icons: Icons.assignment,
                  currentIndex: currentIndex,
                  onPressed: onPressedicon0,
                ),
                BottomIcon(
                  index: 1,
                  icons: Icons.account_balance,
                  currentIndex: currentIndex,
                  onPressed: onPressedicon1,
                ),
                Container(
                  width: size.width * 0.20,
                ),
                BottomIcon(
                  index: 2,
                  icons: Icons.bookmark,
                  currentIndex: currentIndex,
                  onPressed: onPressedicon2,
                ),
                BottomIcon(
                  index: 3,
                  icons: Icons.settings,
                  currentIndex: currentIndex,
                  onPressed: onPressedicon3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
