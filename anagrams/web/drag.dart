import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

List<Element>logoDivs;
var sourceElement;

void dragStartHandler(e) {
  print('dragStartHandler');
  sourceElement = e.currentTarget;
  e.dataTransfer.effectAllowed = 'move';
  e.dataTransfer.setData('text/html', e.currentTarget.innerHtml);
}

void dragEnterHandler(e) {
  print('dragEnterHandler');
  e.currentTarget.classes.add('over');
}

void dragOverHandler(e) {
  print('dragOverHandler');
  e.preventDefault();
  e.dataTransfer.dropEffect = 'move';
}

void dragLeaveHandler(e) {
  print('dragLeaveHandler');
  e.currentTarget.classes.remove('over');
}

void dropHandler(e) {
  print('dropHandler');
  e.stopPropagation();
  if (sourceElement != e.currentTarget) {
    sourceElement.innerHtml = e.currentTarget.innerHtml;
    window.console.log(sourceElement);
    window.console.log(e.currentTarget);
    e.currentTarget.innerHtml = e.dataTransfer.getData('text/html');
  }
}

void dragEndHandler(e) {
  print('dragEndHandler');
  logoDivs.forEach((logoDiv) {
    logoDiv.classes.remove('over');
  });
}

void main() {
  logoDivs = queryAll('.logo-div');
  logoDivs.forEach((charDiv) {
    charDiv.onDragStart.listen(dragStartHandler);
    charDiv.onDragEnter.listen(dragEnterHandler);
    charDiv.onDragOver.listen(dragOverHandler);
    charDiv.onDragLeave.listen(dragLeaveHandler);
    charDiv.onDrop.listen(dropHandler);
    charDiv.onDragEnd.listen(dragEndHandler);
  });
}
