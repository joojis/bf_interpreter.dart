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
          <textarea name="codeTextarea" [(ngModel)]="code" rows=10 placeholder="BrainFuck Code Here"></textarea>
        </div>
        <div class="pure-u-1 pure-u-lg-4-24"></div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-4-24"></div>
        <div class="pure-u-1 pure-u-lg-16-24">
          <button class="pure-button pure-button-primary" (click)="onClickExecute()">Run</button>
        </div>
        <div class="pure-u-1 pure-u-lg-4-24"></div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-4-24"></div>
        <div class="pure-u-1 pure-u-lg-8-24">
          <h3>
          <label for="outputTextarea">Output</label>
          </h3>
          <textarea name="outputTextarea" [(ngModel)]="output" disabled rows=10></textarea>
        </div>
        <div class="pure-u-1 pure-u-lg-8-24">
          <h3>
          <label for="logTextarea">Log (including error)</label>
          </h3>
          <textarea name="logTextarea" [(ngModel)]="log" disabled rows=10></textarea>
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
