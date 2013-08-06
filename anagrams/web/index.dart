import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

List<List<String>> anagrams = [
    ['dater', 'derat', 'rated', 'tared', 'trade', 'tread'],
    ['easting', 'eatings', 'ingates', 'ingesta', 'seating', 'teasing'],
    ['ester', 'reest', 'reset', 'steer', 'stere', 'terse', 'trees'],
    ['least', 'setal', 'slate', 'stale', 'steal', 'stela', 'taels', 'tales',
     'teals', 'tesla'],
    ['leapt', 'lepta', 'palet', 'petal', 'plate', 'pleat', 'tepal'],
    ['argle', 'glare', 'lager', 'large', 'regal'],
    ['alert', 'alter', 'artel', 'later', 'ratel', 'taler'],
    ['aril', 'lair', 'lari', 'liar', 'lira', 'rail', 'rial'],
    ['caret', 'carte', 'cater', 'crate', 'react', 'recta','trace']
];

List<String> chars = toObservable([]);
List<Element>charDivs;
List<String> selectedList;
String selectedWord;
var sourceElement;

void dragStartHandler(e) {
  e.target.style.opacity = '0.25';
  sourceElement = e.target;
  e.dataTransfer.effectAllowed = 'move';
  e.dataTransfer.setData('text/html', e.target.innerHtml);
}

void dragEnterHandler(e) {
  e.target.classes.add('over');
}

void dragOverHandler(e) {
  e.preventDefault();
  e.dataTransfer.dropEffect = 'move';
}

void dragLeaveHandler(e) {
  e.target.classes.remove('over');
}

void dropHandler(e) {
  e.stopPropagation();
  if (sourceElement != e.target) {
    sourceElement.innerHtml = e.target.innerHtml;
    e.target.innerHtml = e.dataTransfer.getData('text/html');
  }
}

void dragEndHandler(e) {
  charDivs.forEach((charDiv) {
    charDiv.classes.remove('over');
  });
  e.target.style.opacity = '1.0';
}

void main() {
  charDivs = queryAll('.char');
  var random = new Random();
  selectedList = anagrams[random.nextInt(anagrams.length)];
  selectedWord = selectedList[random.nextInt(selectedList.length)];
  chars.addAll(selectedWord.split(''));

  charDivs.forEach((charDiv) {
    charDiv.onDragStart.listen(dragStartHandler);
    charDiv.onDragEnter.listen(dragEnterHandler);
    charDiv.onDragOver.listen(dragOverHandler);
    charDiv.onDragLeave.listen(dragLeaveHandler);
    charDiv.onDrop.listen(dropHandler);
    charDiv.onDragEnd.listen(dragEndHandler);
  });
}
