import 'dart:html';

import 'package:bf_interpreter/bf_interpreter.dart';

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