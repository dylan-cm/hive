import 'dart:math';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Beetle()
      ),
    );
  }
}

class Hex extends StatelessWidget {
  const Hex({Key key, this.color, this.elevation}) : super(key: key);

  final Color color;
  final double elevation; 

  @override
  Widget build(BuildContext context) {
    double width = 150;
    return Container(
      width: width,
      height: width * sqrt(3) / 2,
      child: Center(
        child: ClipPolygon(  
          sides: 6, 
          borderRadius: 5.0,
          rotate: 90.0,
          boxShadows: [ PolygonBoxShadow(color: Colors.black, elevation: elevation) ],
          child: Container(color: color),
        ),
      ),
    );
  }
}

class Bee extends StatefulWidget {
  @override
  _BeeState createState() => _BeeState();
}

class _BeeState extends State<Bee> {
  bool movesVisible;
  List<Widget> moves;

  @override
  void initState() {
    super.initState();
    movesVisible = false;
    moves = [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment(0,0),
          child: GestureDetector(
            onTap: onTap,
            child: Hex(
              color: Colors.yellow,
              elevation: 0.0,
            ),
          ),
        ),
      ] + moves,
    );
  }

  void onTap(){
    setState((){
      moves = movesVisible ?calcMoves() :[] ;
      movesVisible=!movesVisible;
    });
  }

  List<Widget> calcMoves(){
    List<Widget> moves = [];
    List<dynamic> coords = [
      {'x':0.0, 'y':-0.5},
      {'x':0.0, 'y':0.5},
      {'x':0.75 / sqrt(3) * 2, 'y':0.25},
      {'x':0.75 / sqrt(3) * 2, 'y':-0.25},
      {'x':-0.75 / sqrt(3) * 2, 'y':0.25},
      {'x':-0.75 / sqrt(3) * 2, 'y':-0.25},
    ];
    for(var i = 0; i<coords.length; i++){
      moves.add(
        Container(
          alignment: Alignment(coords[i]['x'],coords[i]['y']),
          child: GestureDetector(
            onTap: onTap,
            child: Hex(
              color: Colors.blueGrey[100],
              elevation: 0.0,
            ),
          ),
        )
      );
    }

    return moves;
  }
}

class Beetle extends StatefulWidget {
  @override
  _BeetleState createState() => _BeetleState();
}

class _BeetleState extends State<Beetle> {
  bool movesVisible;
  List<Widget> moves;

  @override
  void initState() {
    super.initState();
    movesVisible = false;
    moves = [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment(0,0),
          child: GestureDetector(
            onTap: onTap,
            child: Hex(
              color: Colors.purple,
              elevation: 0.0,
            ),
          ),
        ),
      ] + moves,
    );
  }

  void onTap(){
    setState((){
      moves = movesVisible ?calcMoves() :[] ;
      movesVisible=!movesVisible;
    });
  }

  List<Widget> calcMoves(){
    List<Widget> moves = [];
    List<dynamic> coords = [
      {'x':0.0, 'y':-0.5},
      {'x':0.0, 'y':0.5},
      {'x':0.75 / sqrt(3) * 2, 'y':0.25},
      {'x':0.75 / sqrt(3) * 2, 'y':-0.25},
      {'x':-0.75 / sqrt(3) * 2, 'y':0.25},
      {'x':-0.75 / sqrt(3) * 2, 'y':-0.25},
    ];
    for(var i = 0; i<coords.length; i++){
      moves.add(
        Container(
          alignment: Alignment(coords[i]['x'],coords[i]['y']),
          child: GestureDetector(
            onTap: onTap,
            child: Hex(
              color: Colors.blueGrey[100],
              elevation: 0.0,
            ),
          ),
        )
      );
    }

    return moves;
  }
}