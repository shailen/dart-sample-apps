var body = document.body,
    canvas = document.getElementById('canvas'),
    ctx = canvas.getContext('2d'),
    waitTime = 10,
    lastX,
    lastY,
    nextX,
    nextY,
    draw = false;

// Set canvas to full screen
canvas.width  = window.innerWidth;
canvas.height = window.innerHeight;

// Set brush width to thick
ctx.lineWidth = 5;
ctx.lineCap = 'round';
ctx.lineJoin = 'round';
ctx.strokeStyle = 'rgb(250,250,125)';

function _eventWrapper(fn) {
  return function (e) {
    // Get the true event
    e = e || window.event;

    // Method to prevent default behavior
    if( !e.preventDefault ) {
      e.preventDefault = function () {
        e.returnValue = false;
      };
    }

    // Method to stop propagation
    if( !e.stopPropagation ) {
      e.stopPropagation = function () {
        e.cancelBubble = true;
      };
    }

    // Method to stop everything
    e.stopNormal = function () {
      e.preventDefault();
      e.stopPropagation();
    };

    // Invoke fn with wrapped event
    fn(e);
  }
}


// Sets the value of nextX and nextY
var _moveFn = _eventWrapper(function (e) {
      // Stop normal default behavior/bubbling
      e.stopNormal();

      // Mark the stroke down
      nextX = e.clientX;
      nextY = e.clientY;
    }),

    _upFn = _eventWrapper(function (e) {
      // Stop normal default behavior/bubbling
      e.stopNormal();

      // Remove bindings
      body.onmousemove = null;
      body.onmouseup = null;
      draw = false;
    });

// Bind onclick watching
body.onmousedown = _eventWrapper(function (e) {
  // Stop normal default behavior/bubbling
  e.stopNormal();

  // Memoize current location. Why does this not work?
  lastX = nextX = e.clientX;
  lastY = nextY = e.clientY;

  // Bind any motion and halting
  body.onmousemove = _moveFn;
  body.onmouseup = _upFn;
  draw = true;
  drawLine();
});

// Only watch mouse position over the course of the wait time
function drawLine() {
  if( !draw ) {
    return;
  }

  _drawLine(lastX, lastY, nextX, nextY);

  // Save position for next move
  lastX = nextX;
  lastY = nextY;

  // Async call self
  setTimeout(drawLine, waitTime);
}

function _drawLine(lastX, lastY, nextX, nextY) {
  // Start path
  ctx.beginPath();
  ctx.moveTo(lastX, lastY);

  // Continue path
  ctx.lineTo(nextX, nextY);
  ctx.stroke();

  // Terminate path
  ctx.closePath();
}
