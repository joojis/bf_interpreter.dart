import 'dart:html';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';

import 'package:bf_interpreter/bf_interpreter.dart';

@Component(
    selector: 'program',
    template: '''
      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-4-24"></div>
        <div class="pure-u-1 pure-u-lg-16-24">
          <label for="codeTextarea">BF Code</label>
          <textarea name="codeTextarea" [(ngModel)]="code"></textarea>
        </div>
        <div class="pure-u-1 pure-u-lg-4-24"></div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-4-24"></div>
        <div class="pure-u-1 pure-u-lg-16-24">
          <button (click)="onClickExecute()">Execute</button>
        </div>
        <div class="pure-u-1 pure-u-lg-4-24"></div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-4-24"></div>
        <div class="pure-u-1 pure-u-lg-8-24">
          <label for="outputTextarea">Runtime Output</label>
          <textarea name="outputTextarea" [(ngModel)]="output"></textarea>
        </div>
        <div class="pure-u-1 pure-u-lg-8-24">
          <label for="logTextarea">Program Log(including error)</label>
          <textarea name="logTextarea" [(ngModel)]="log"></textarea>
        </div>
        <div class="pure-u-1 pure-u-lg-4-24"></div>
      </div>
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
