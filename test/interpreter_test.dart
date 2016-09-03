import "package:bf_interpreter/bf_interpreter.dart";
import "package:test/test.dart";
import "dart:io";

testBF(str) async {
  var loader = new BFTextLoader();
  var expected = new File('${str}.expected').readAsStringSync() ;
  var program = new Program(await loader.load('${str}.bf'));
  var buffer = new StringBuffer();
  await for (var code in program.run()) {
    buffer.writeCharCode(code);
  }
  expect(buffer.toString(), equals(expected));
}

void main() {
  test("run BF", () async {
    await testBF('test1');
  });
}