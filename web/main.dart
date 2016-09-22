import 'dart:html';

import 'package:bf_interpreter/bf_interpreter.dart';

/*
TextAreaElement programInput, stdinInput, stdoutInput, stderrInput;

final programCharactersWithEscape = r"+-<>.,[]".replaceAllMapped(new RegExp('.'), (match) => '\\${match.group(0)}');

runProgram() async {
  var prog = new Program(programInput.value.replaceAll(new RegExp('[^${programCharactersWithEscape}]'), ''));
  var outBuffer = new StringBuffer();
  await for (var ch in prog.run()) {
    outBuffer.writeCharCode(ch);
  }
  stdoutInput.value = outBuffer.toString();
}

void main() {
  programInput = querySelector('textarea#program');
  stdinInput = querySelector('textarea#stdin');
  stdoutInput = querySelector('textarea#stdout');
  stderrInput = querySelector('textarea#stderr');

  querySelector('#executeButton').addEventListener('click', (e) {
    print('click event: ${e}!');
    print('program: ${programInput.value}');
    runProgram();
  });
}
*/

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';

@Component(
    selector: 'program',
    template: '''
        <textarea></textarea>
        {{mmm}}
        <button (click)="onClickMe()">Click Me!</button>'''
)
class ProgramComponent {
  String mmm = 'ha';
  void onClickMe() {
    mmm += 'ha';
  }
}

@Component(
    selector: 'my-app',
    template: '<h1>My First Angular 2 App</h1><program></program>'
)
class AppComponent {}

void main ()
{
  bootstrap(AppComponent);
  bootstrap(ProgramComponent);
}