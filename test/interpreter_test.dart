import "dart:io";

import "package:bf_interpreter/bf_interpreter.dart";
import "package:test/test.dart";

class BFTextLoader {
  load (String filepath) async {
    final stream = new File(filepath).openRead();
    StringBuffer buf = new StringBuffer();
    await for (final data in stream) {
      for (final charCode in data) {
        buf.writeCharCode(charCode);
      }
    }
    return buf.toString();
  }
}

testBF(str) async {
  final pathPrefix = 'test/bf_testcases/';
  final expected = new File('${pathPrefix + str}.expected').readAsStringSync() ;
  final program = new Program(new File('${pathPrefix + str}.bf').readAsStringSync());
  final buffer = new StringBuffer();
  await for (final code in program.run()) {
    buffer.writeCharCode(code);
  }
  expect(buffer.toString(), equals(expected));
}

void main() {
  test("interpreter should be able to run BF codes.", () async {
    await testBF('hello_world_1');
    await testBF('hello_world_2');
    await testBF('big_array');
    await testBF('obscure');
  });
}