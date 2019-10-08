// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/animation.dart';

// This app is a stateful, it tracks the user's current choice.
class BasicAppBarSample extends StatefulWidget {
  @override
  _BasicAppBarSampleState createState() => _BasicAppBarSampleState();
}

class _BasicAppBarSampleState extends State<BasicAppBarSample>
    with SingleTickerProviderStateMixin {
  // --- this block is related to the menu selection
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  // --- this block is related to the car rotation
  int _direction = 0;
  _turn(int value) {
    setState(() {
      _direction = ((_direction + value) % 4);
      _direction = _direction < 0 ? 4 : _direction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Basic AppBar'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(choices[0].icon),
            onPressed: () {
              _select(choices[0]);
            },
          ),
          // action button
          IconButton(
            icon: Icon(choices[1].icon),
            onPressed: () {
              _select(choices[1]);
            },
          ),
          // overflow menu
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text('${choice.title}'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
//            ChoiceCard(choice: _selectedChoice),
            Expanded(
              flex: 3,
              child: TheCar(direction: _direction),
            ),
            Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  RaisedButton(
                    child: Text('Left'),
                    onPressed: () {
                      _turn(-1);
                    },
                  ),
                  RaisedButton(
                    child: Text('Right'),
                    onPressed: () {
                      _turn(1);
                    },
                  ),
                ])),
          ])),
    ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Here is the painting
    final paint = Paint();

    paint.color = Colors.orangeAccent;

    var path = Path();
    var _roadWidth = 100;
    for ( var i = 1; i <= 10; i++) {
      canvas.drawRect(
          Rect.fromLTWH((size.width / 2) - _roadWidth, 40.0 * i, 10, 20), paint);
      canvas.drawRect(
          Rect.fromLTWH((size.width / 2) + _roadWidth, 40.0 * i, 10, 20), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TheCar extends StatelessWidget {
  TheCar({Key key, this.direction = 0}) : super(key: key);

  // 0 - up
  // 1 - right
  // 2 - down
  // 3 - left
  final int direction;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: direction,
        child: CustomPaint(
            painter: MyPainter(),
            child: Image.asset(
              'assets/theCar.png',
              fit: BoxFit.scaleDown,
            )
        )
    );
  }
}





















// -------------- old stuff
// -------------- old stuff
// -------------- old stuff

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Cradle', icon: Icons.child_friendly),
  const Choice(title: 'Face', icon: Icons.child_care),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;
  AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    // Play sound
    // https://github.com/luanpotter/audioplayers/blob/master/doc/audio_cache.md
//    AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY)
//    audioPlayer.play(url)
    // this is primitive playing from the assets.
    // TODO: change it to the AudioPlayer as described above
    if (choice.title == 'Face') {
      player.play('sound1.mp3');
    }

    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
//          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(BasicAppBarSample());
}
