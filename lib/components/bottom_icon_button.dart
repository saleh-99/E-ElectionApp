import 'package:flutter/material.dart';

class BottomIcon extends StatelessWidget {
  const BottomIcon({
    @required this.currentIndex,
    @required this.onPressed,
    @required this.icons,
    @required this.index,
  });

  final int currentIndex;
  final int index;
  final Function onPressed;
  final IconData icons;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      onPressed: onPressed,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: Icon(
              icons,
              color:
                  currentIndex == index ? Colors.orange : Colors.grey.shade400,
            ),
          ),
          currentIndex == index
              ? Text(
                  'cologe',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.orange,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
