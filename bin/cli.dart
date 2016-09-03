import 'dart:io';
import 'package:bf_interpreter/bf_interpreter.dart';

main () async {
  var stream = new File("test1.bf").openRead();
  StringBuffer buf = new StringBuffer();
  await for (var data in stream) {
    for (var charCode in data) {
      if (isCodeUnitOperator(charCode)) {
        buf.writeCharCode(charCode);
      }
    }
  }
  var prog = new Program(buf.toString());
  try {
    await for (var code in prog.run()) {
      stdout.write(new String.fromCharCode(code));
    }
  } catch (e) {
    print('\nerror: $e');
  }
  // print(InstructionType.values[0]);
}