import 'dart:html';
import 'package:web_ui/web_ui.dart';

// initial value for click-counter
int startingCount = 0;
List<String>things = toObservable(['1', '2', '3', '4',
                                   '5', '6', '7', '8',
                                   '9', '10', '11', '12',
                                   '13', '14', '15', '']);

void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
}
