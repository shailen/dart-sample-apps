import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'dart:collection';

@observable
String selectedThickness = 'Medium';
LinkedHashMap<String, int> thicknessMap = {'Super-thin' : 3,
                                           'Thin' : 6,
                                           'Medium': 12,
                                           'Thick' : 24,
                                           'Super-thick': 48};

@observable
String selectedColor = 'yellow';
LinkedHashMap<String, int> colorsMap = {'red'    : 'rgb(180,30, 20)',
                                        'green'  : 'rgb(30,180,20)',
                                        'yellow' : 'rgb(250,250,125)'};

class Doodle {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  int lastX, lastY, nextX, nextY;
  bool draw = false;
  var subscription;
  DataModel dataModel;
  List temp = [];

  Doodle(this.canvas) {
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;

    ctx = canvas.getContext('2d');
    ctx.lineWidth = thicknessMap[selectedThickness];
    ctx.lineCap = 'round';
    ctx.strokeStyle = colorsMap[selectedColor];
    dataModel = new DataModel();
  }

  void begin() {
    canvas.onMouseDown.listen((MouseEvent e) {
      e.preventDefault();
      e.stopPropagation();

      lastX = nextX = e.client.x;
      lastY = nextY = e.client.y;

      subscription = canvas.onMouseMove.listen(mouseMoveCallback);
      canvas.onMouseUp.listen(mouseUpCallback);
      draw = true;
      dataModel.paths.add(new PathData(lastX, lastY, nextX, nextY, ctx.strokeStyle, ctx.lineWidth, true));
      drawLine();
    });
  }

  void mouseMoveCallback(MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();
    nextX = e.client.x;
    nextY = e.client.y;
    dataModel.paths.add(new PathData(lastX, lastY, nextX, nextY, ctx.strokeStyle, ctx.lineWidth));
    drawLine();
  }

  void mouseUpCallback(MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();
    subscription.cancel();
    draw = false;
  }

  clearCanvas() {
    canvas.width = canvas.width;
    print(identical(canvas, ctx.canvas));
  }

  drawLine() {
    ctx.lineWidth = thicknessMap[selectedThickness];
    ctx.strokeStyle = colorsMap[selectedColor];

    if (!draw) return;
    _drawLine(lastX, lastY, nextX, nextY);

    lastX = nextX;
    lastY = nextY;
  }

  drawEverything() {
    if (!draw) return;

    clearCanvas();
    for (var i = 0; i < dataModel.paths.length; i++) {
      ctx.lineWidth = dataModel.paths[i].lineWidth;
      ctx.strokeStyle = dataModel.paths[i].strokeStyle;
      _drawLine(dataModel.paths[i].lastX,
                dataModel.paths[i].lastY,
                dataModel.paths[i].nextX,
                dataModel.paths[i].nextY);
      lastX = nextX;
      lastY = nextY;

    }
    print(dataModel.paths);
  }

  _drawLine(lastX, lastY, nextX, nextY) {
    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(nextX, nextY);
    ctx.stroke();
    ctx.closePath();
  }
}

class DataModel {
  List<PathData> paths = [];
}

class PathData {
  num lastX, lastY, nextX, nextY;
  String strokeStyle;
  num lineWidth;
  bool onMouseDown;

  PathData(this.lastX, this.lastY, this.nextX, this.nextY,
       this.strokeStyle, this.lineWidth, [this.onMouseDown = false]);

  String toString() => '[$lastX, $lastY, $nextX, $nextY, $strokeStyle, $lineWidth, $onMouseDown]';
}

void main() {
  var doodle = new Doodle(query('canvas'));
  doodle.begin();
}
