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
  Map<int, Map<int, Piece>> board = {0 : {0 : Beetle(Hex(0,0))}};

  @override
  void initState() {
    super.initState();
    visibleMoves = [];
    pieces = [
      Beetle(Hex(0,1)),
      Bee(Hex(0,2)),
      Ant(Hex(1,1)),
      Grasshopper(Hex(0,3)),
      Spider(Hex(2,1)),
      Mosquito(Hex(1,2)),
      LadyBug(Hex(1,3)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    HexLayout layout = HexLayout.orientFlat(Point(45, 45), Point(0,0));
    List<Widget> children = [];

    for(Piece piece in pieces){
      if(board[piece.hex.r]==null) board[piece.hex.r]={};
      board[piece.hex.r][piece.hex.q] = piece;
      children.add(
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
        if(validateMove(move.hex)) children.add(
          Positioned(
            left: move.hex.toPixel(layout).x,
            top: move.hex.toPixel(layout).y,
            child: GestureDetector(
              onTap: ()=>moveTo(selectedPiece, move.hex),
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
          children: children,
        )
      ),
    );
  }

  bool validateMove(Hex target){
    List<Hex> neighbors = [];
    List<Hex> spaces = [];
    List<Hex> targetNeighbors = [];
    List<Hex> targetSpaces = [];
    for(int i=0; i<6; i++) {
      if(board[selectedPiece.hex.neighbor(i).r]==null) board[selectedPiece.hex.neighbor(i).r] = {};
      if (board[selectedPiece.hex.neighbor(i).r][selectedPiece.hex.neighbor(i).q]!=null){
        neighbors.add(selectedPiece.hex.neighbor(i));
      } else spaces.add(selectedPiece.hex.neighbor(i));
    }
    for(int i=0; i<6; i++) {
      if(board[target.neighbor(i).r]==null) board[target.neighbor(i).r] = {};
      if (board[target.neighbor(i).r][target.neighbor(i).q]!=null){
        targetNeighbors.add(target.neighbor(i));
      } else targetSpaces.add(target.neighbor(i));
    }
    bool spaceEmpty = board[target.r]==null || board[target.r][target.q]==null;
    bool connectedSpace = pieces.firstWhere((piece)=>distance(piece.hex, target)==1&&piece.hex!=selectedPiece.hex, orElse: ()=>null)!=null;
    bool fourNeigborsOrLess = neighbors.length <= 4;
    bool spaceToSlideOut = neighbors.length!=4 ? true : distance(spaces[0], spaces[1])==1;
    // bool spaceToSlideIn = targetNeighbors.length >= 4 ? false : targetSpaces[0].q==targetSpaces[1].q || targetSpaces[0].r==targetSpaces[1].r;
    bool unbrokenChain2 = neighbors.length!=2 ? true : distance(neighbors[0], neighbors[1])==1;
    bool unbrokenChain3 = neighbors.length!=3 ? true : distance(neighbors[0], neighbors[1])+distance(neighbors[1], neighbors[2])==2;
    return spaceEmpty && connectedSpace && fourNeigborsOrLess && spaceToSlideOut && unbrokenChain2 && unbrokenChain3 && true;
  }

  int distance(Hex a, Hex b) => (((a.q - b.q).abs() + (a.r - b.r).abs() + (a.q + a.r - b.q - b.r).abs())/2).toInt();

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

  moveTo(Piece piece, Hex target){
    setState(() {
      visibleMoves = [];
      selectedPiece = null;
      pieces.removeWhere((_piece)=>_piece.hex==piece.hex);
      pieces.add(piece.moveTo(target));
      board[piece.hex.r][piece.hex.q] = null;
      if(board[target.r]==null) board[target.r] = {};
      board[target.r][target.q] = piece;
    });
  }
}

class Beetle extends Piece{
  Beetle(this.hex)
    : this.color = Colors.purple,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Beetle moveTo(newHex) => Beetle(newHex);
}
class Bee extends Piece{
  Bee(this.hex)
    : this.color = Colors.yellow,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Bee moveTo(newHex) => Bee(newHex);
}
class Spider extends Piece{
  Spider(this.hex)
    : this.color = Colors.orange,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Spider moveTo(newHex) => Spider(newHex);
}
class Ant extends Piece{
  Ant(this.hex)
    : this.color = Colors.blue,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Ant moveTo(newHex) => Ant(newHex);
}
class Grasshopper extends Piece{
  Grasshopper(this.hex)
    : this.color = Colors.green,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Grasshopper moveTo(newHex) => Grasshopper(newHex);
}
class LadyBug extends Piece{
  LadyBug(this.hex)
    : this.color = Colors.red,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  LadyBug moveTo(newHex) => LadyBug(newHex);
}
class Mosquito extends Piece{
  Mosquito(this.hex)
    : this.color = Colors.blueGrey,
      this.moves = [
        Move(hex: Hex(hex.q, hex.r+1)),
        Move(hex: Hex(hex.q, hex.r-1)),
        Move(hex: Hex(hex.q+1, hex.r)),
        Move(hex: Hex(hex.q+1, hex.r-1)),
        Move(hex: Hex(hex.q-1, hex.r+1)),
        Move(hex: Hex(hex.q-1, hex.r)),
      ];

  final Hex hex;
  final Color color;
  final List<Move> moves;

  Mosquito moveTo(newHex) => Mosquito(newHex);
}

abstract class Piece extends StatelessWidget {
  const Piece({Key key, this.color, this.hex, this.moves}) : super(key: key);
  
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

  Piece moveTo(Hex newHex);
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