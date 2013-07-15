import 'dart:html';

List<AudioElement> sounds = new List<AudioElement>() ;
List<String> noteNames = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C2'];

void main() {
  for (var name in noteNames) {
    print(name);
		sounds.add(new AudioElement("../sounds/" + name + ".ogg"));
  }
  print(sounds);

  query('#notes').onClick.listen((event) {
    var note = event.target.id;
    print(note);
    var index = noteNames.indexOf(note);
    window.console.log(sounds[index]);
    sounds[index].play();
  });
}


