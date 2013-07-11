import 'package:web_ui/web_ui.dart';
import 'dart:math' as Math;
import 'dart:html';

class TableComponent extends WebComponent {
  @observable
  int count = 0;
  List<String> things;

  void begin() {
    _shuffle(things);
  }

  void _shuffle(list) {
    var random = new Math.Random();
    for (var i = list.length - 2; i > 1; i--) {
      var j = random.nextInt(i);
      var temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  inserted() {
    TableElement table = query('table');
    if (table == null) return;

    table.onClick.listen((Event event) {
      if (!(event.target is TableCellElement)) return;

      String value = event.target.text.trim();
      int valueIndex = things.indexOf(value);
      int emptyStringIndex = things.indexOf('');
      int diff = (valueIndex - emptyStringIndex).abs();
      if (diff == 1 || diff == 4) {
        var temp = things[valueIndex];
        things[valueIndex] = things[emptyStringIndex];
        things[emptyStringIndex] = temp;
        count++;
      }
    });
  }
}
