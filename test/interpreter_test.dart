import "package:bf_interpreter/bf_interpreter.dart";
import "package:test/test.dart";
import "dart:io";

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
    await testBF('my_first_name');
    await testBF('hello_world_1');
    await testBF('hello_world_2');
  });
}