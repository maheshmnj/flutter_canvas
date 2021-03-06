import 'package:canvas/cursor.dart';
import 'package:canvas/point.dart';
import 'package:canvas/whiteboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget leading;
  Color selectedColor;
  Function onPenTapped;
  Function onEraserTapped;
  Function onColorTapped;
  final BuildContext context;
  final List<Widget> actions;
  int totalPoints = 0; // multiples of 100

  Widget colorBoxWidget() {
    return Container(color: selectedColor, width: 35, height: 35);
  }

  AppBarWidget(
      {Key key,
      this.title,
      this.leading,
      this.context,
      this.actions,
      this.onColorTapped,
      this.selectedColor,
      this.onEraserTapped,
      this.onPenTapped})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Point>(
      context,
      listen: false,
    );

    return StreamBuilder<List<Point>>(
        stream: points.controller.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Point>> snapshot) {
          return Container(
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Cursor(
                  cursorStyle: Cursor.pointer,
                  child: Wrap(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.undo,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            List<Point> newList = [];
                            if (snapshot.data != null) {
                              List<Point> pointsList = [];
                              pointsList = snapshot.data;
                              for (int i = 0;
                                  i < pointsList.length - 100;
                                  i++) {
                                newList.add(pointsList[i]);
                              }
                            }
                            points.controller.sink.add(newList);
                            store.points = newList;
                          }),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.redo,
                      //       color: Colors.white,
                      //     ),
                      //     onPressed: () {
                      //       final List<Point> totalPoints = store.points;
                      //       for (int i = 0; i < 100; i++) {

                      //       }
                      //     }),
                    ],
                  ),
                ),
                Cursor(
                  cursorStyle: Cursor.pointer,
                  child: Wrap(
                    children: <Widget>[
                      GestureDetector(
                        onTap: onColorTapped,
                        child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: colorBoxWidget()),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.brush,
                            color: Colors.white,
                          ),
                          onPressed: onPenTapped),
                      IconButton(
                          icon: Icon(
                            Icons.radio_button_checked,
                            color: Colors.white,
                          ),
                          onPressed: onEraserTapped),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
