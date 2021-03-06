import 'dart:html';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';

import 'package:bf_interpreter/bf_interpreter.dart';

@Component(
    selector: 'program',
    template: '''
      <div class="pure-g">
        <div class="pure-u-1">
          <textarea
            name="codeTextarea"
            [(ngModel)]="code"
            (keydown.control.enter)="onCtrlEnter()"
            rows=10
            placeholder="BrainFuck Code Here"></textarea>
        </div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1">
          <button class="pure-button pure-button-primary" (click)="onClickExecute()">Run (Control+Enter)</button>
        </div>
      </div>

      <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-12-24">
          <h3>
          <label for="outputTextarea">Output</label>
          </h3>
          <textarea name="outputTextarea" [(ngModel)]="output" disabled rows=10></textarea>
          <pre>{{outputHelpString}}</pre>
        </div>
        <div class="pure-u-1 pure-u-lg-1-24"></div>
        <div class="pure-u-1 pure-u-lg-11-24">
          <h3>
          <label for="logTextarea">Log (including error)</label>
          </h3>
          <table class="pure-table pure-table-horizontal">
            <tbody>
              <tr *ngIf="logs.length == 0">
                <td>The logs will be appeared here after running program.</td>
              </tr>
              <tr *ngFor="let log of logs">
                <td>{{log}}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="pure-u-1 pure-u-lg-1-24"></div>
      </div>
      <footer>
        <center>
          <a href="https://github.com/joojis/bf_interpreter.dart">View on GitHub</a> authored by (Jeong Jin Gyeong)
        </center>
      </footer>
    '''
)
class ProgramComponent {
  String code = '';
  String output = '';
  String outputHelpString = '';
  List<String> logs = [];

  void onCtrlEnter() {
    run();
  }

  void onClickExecute() {
    run();
  }

  void run() async {
    final program = new Program(code);
    outputHelpString = '';
    try {
      output = '';
      await for (final ch in program.run()) {
        output += new String.fromCharCode(ch);
      }
    } on Error {
      outputHelpString += 'Program exited with an error.\n';
    } finally {
      outputHelpString += 'Output length: ${output.length}\n';
      logs = [];
      await for (final log in program.getLogStream()) {
        logs.add(log);
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
