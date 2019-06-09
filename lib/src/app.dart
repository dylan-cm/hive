import 'dart:math';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:hexagonal_grid/hexagonal_grid.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Move> visibleMoves;
  Piece selectedPiece;
  List pieces = [];

  @override
  void initState() {
    super.initState();
    visibleMoves = [];
    pieces = [
      Piece( color: Colors.red, hex: Hex(0,1), ),
      Piece( color: Colors.blue, hex: Hex(2,2), ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    HexLayout layout = HexLayout.orientFlat(Point(45, 45), Point(0,0));
    List<Widget> board = [];

    for(Piece piece in pieces){
      board.add(
        Positioned(
          left: piece.hex.toPixel(layout).x,
          top: piece.hex.toPixel(layout).y,
          child: GestureDetector(
            onTap: ()=>selectPiece(piece),
            child: piece
          ),
        )
      );
      for(Move move in visibleMoves){
        board.add(
          Positioned(
            left: move.hex.toPixel(layout).x,
            top: move.hex.toPixel(layout).y,
            child: GestureDetector(
              onTap: ()=>moveTo(piece, move.hex),
              child: move
            ),
          )
        );
      }
    }
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: board,
        )
      ),
    );
  }

  selectPiece(Piece piece) {
    piece.hex == (selectedPiece==null ? null : selectedPiece.hex)
    ? setState((){
      visibleMoves=[];
      selectedPiece = null;
    }) 
    : setState((){
      visibleMoves=piece.moves;
      selectedPiece = piece;
    });
  }

  moveTo(Piece piece, Hex newHex){
    setState(() {
      visibleMoves = [];
      selectedPiece = null;
      pieces.removeWhere((_piece)=>_piece.hex==piece.hex);
      pieces.add(Piece(hex: newHex, color: piece.color,));
    });
  }
}

class Piece extends StatelessWidget {
  Piece({Key key, this.color, hex}) 
  : this.hex = hex,
    moves = [
      Move(hex: Hex(hex.q, hex.r+1)),
      Move(hex: Hex(hex.q, hex.r-1)),
      Move(hex: Hex(hex.q+1, hex.r)),
      Move(hex: Hex(hex.q+1, hex.r-1)),
      Move(hex: Hex(hex.q-1, hex.r+1)),
      Move(hex: Hex(hex.q-1, hex.r)),
    ],
    super(key: key);
  
  final Color color;
  final Hex hex;
  final List<Move> moves;

  @override
  Widget build(BuildContext context) {
    double size = 50;
    return Container(
      width: 2 * size,
      height: sqrt(3) * size,
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

class Move extends StatelessWidget {
    const Move({Key key, this.color, this.hex}) : super(key: key);
  
  final Color color;
  final Hex hex;

  @override
  Widget build(BuildContext context) {
    double size = 50;
    return Container(
      width: 2 * size,
      height: sqrt(3) * size,
      child: Material(
        shape: PolygonBorder(
          sides: 6,
          borderRadius: 5.0,
          rotate: 90.0,
          border: BorderSide(color: Colors.cyanAccent, width: 5.0),
        ),
        color: Colors.transparent,
      )
    );
  }
}