import "dart:io";

import "package:bf_interpreter/bf_interpreter.dart";
import "package:test/test.dart";

class BFTextLoader {
  load (String filepath) async {
    var stream = new File(filepath).openRead();
    StringBuffer buf = new StringBuffer();
    await for (var data in stream) {
      for (var charCode in data) {
        buf.writeCharCode(charCode);
      }
    }
    return buf.toString();
  }
}

testBF(str) async {
  final pathPrefix = 'test/bf_testcases/';
  var loader = new BFTextLoader();
  var expected = new File('${pathPrefix + str}.expected').readAsStringSync() ;
  var program = new Program(await loader.load('${pathPrefix + str}.bf'));
  var buffer = new StringBuffer();
  await for (var code in program.run()) {
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