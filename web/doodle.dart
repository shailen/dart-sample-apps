import 'dart:html';
import 'dart:async';

class Doodle {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  int lastX, lastY, nextX, nextY;
  bool draw = false;
  var subscription;
  int waitTime = 10;


  Doodle(this.canvas) {
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;

    ctx = canvas.getContext('2d');
    ctx.lineWidth = 5;
    ctx.lineCap = 'round';
    ctx.strokeStyle = 'rgb(250,250,125)';
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
      drawLine();
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
    if ( !draw ) return;

    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(nextX, nextY);
    ctx.stroke();
    ctx.closePath();

    lastX = nextX;
    lastY = nextY;
  }
}

void main() {
  var doodle = new Doodle(query('canvas'));
  doodle.begin();
}