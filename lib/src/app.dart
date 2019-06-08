import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(child: Bee()),
      ),
    );
  }
}

class Hex extends StatelessWidget {
  const Hex({Key key, this.color}) : super(key: key);

  final Color color;

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
          boxShadows: [ PolygonBoxShadow(color: Colors.black, elevation: 2.0) ],
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
  List<Hex> moves;

  @override
  void initState() {
    super.initState();
    movesVisible = false;
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hex(
        color: Colors.yellow,
      ),
    );
  }

  void onTap(){
    setState(()=>movesVisible=true);
  }
}