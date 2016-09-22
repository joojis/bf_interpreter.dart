import 'dart:html';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';

import 'package:bf_interpreter/bf_interpreter.dart';

@Component(
    selector: 'program',
    template: '''
      <label for="codeTextarea">BF Code</label>
      <textarea name="codeTextarea" [(ngModel)]="code"></textarea>

      <button (click)="onClickExecute()">Execute</button>

      <label for="outputTextarea">Runtime Output</label>
      <textarea name="outputTextarea" [(ngModel)]="output"></textarea>

      <label for="logTextarea">Program Log(including error)</label>
      <textarea name="logTextarea" [(ngModel)]="log"></textarea>
    '''
)
class ProgramComponent {
  String code = '';
  String output = '';
  String log = '';

  void onClickExecute() async {
    final program = new Program(code);
    try {
      output = '';
      await for (final ch in program.run()) {
        output += new String.fromCharCode(ch);
      }
    } finally {
      log = '';
      await for (final line in program.getLogStream()) {
        log += line + '\n';
      }
    }
  }
}

@Component(
    selector: 'my-app',
    template: '<h1>BrainFuck Interpreter</h1><program></program>'
)
class AppComponent {}

void main ()
{
  bootstrap(AppComponent);
  bootstrap(ProgramComponent);
}
