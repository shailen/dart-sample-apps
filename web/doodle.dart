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

  Doodle(this.canvas) {
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;

    ctx = canvas.getContext('2d');
    ctx.fillStyle = '#333';
    ctx.lineWidth = thicknessMap[selectedThickness];
    ctx.lineCap = 'round';
    ctx.strokeStyle = colorsMap[selectedColor];
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
    });
  }

  void mouseMoveCallback(MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();
    nextX = e.client.x;
    nextY = e.client.y;
    drawLine();
  }

  void mouseUpCallback(MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();
    subscription.cancel();
    draw = false;
  }

  drawLine() {
    ctx.lineWidth = thicknessMap[selectedThickness];
    ctx.strokeStyle = colorsMap[selectedColor];

    if (!draw) return;
    _drawLine(lastX, lastY, nextX, nextY);

    lastX = nextX;
    lastY = nextY;

    // new Timer(const Duration(milliseconds: 10), drawLine);
  }

  _drawLine(lastX, lastY, nextX, nextY) {
    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(nextX, nextY);
    ctx.stroke();
    ctx.closePath();
  }
}


void main() {
  var doodle = new Doodle(query('canvas'));
  window.console.log(doodle.ctx);
  doodle.begin();

  queryAll('option').forEach((option) {
    option.onSelect.listen((event) => window.console.log(event.target.value));
  });
}
