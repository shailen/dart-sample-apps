import 'dart:html';
import 'dart:async';

int lastX, lastY, nextX, nextY;
bool draw = false;
var subscription;
int waitTime = 10;
var ctx;

void _moveFn(MouseEvent e) {
  e.preventDefault();
  e.stopPropagation();
  nextX = e.client.x;
  nextY = e.client.y;
  drawLine();
}

void _upFn(MouseEvent e) {
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

void _drawLine(lastX, lastY, nextX, nextY) {

}

void main() {
  var canvas = query('#canvas');
  ctx = canvas.getContext('2d');
  canvas.width = canvas.clientWidth;
  canvas.height = canvas.clientHeight;
  ctx.lineWidth = 5;
  ctx.lineCap = 'round';
  ctx.strokeStyle = 'rgb(250,250,125)';

  canvas.onMouseDown.listen((MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();

    lastX = nextX = e.client.x;
    lastY = nextY = e.client.y;

    subscription = canvas.onMouseMove.listen(_moveFn);
    canvas.onMouseUp.listen(_upFn);
    draw = true;
    drawLine();
  });
}