import 'dart:io';

import 'package:bf_interpreter/bf_interpreter.dart';

String _getDefaultFilepath() {
  final segments = Platform.script.pathSegments;
  return (segments.sublist(0, segments.length - 2)
      ..addAll(['test', 'bf_testcases', 'hello_world_1.bf']))
      .join('/');
}

main (List<String> arguments) async {
  final file = new File(arguments.length > 0 ? arguments[0] : _getDefaultFilepath());
  if (!file.existsSync()) {
    print('File not exists: ${file.absolute.path}');
    return;
  }

  final program = new Program(file.readAsStringSync());
  print('---------- Program Start    ----------');
  try {
    await for (final ch in program.run()) {
      stdout.writeCharCode(ch);
    }
  } finally {
    print('---------- Program Finished ----------');
    await for (final log in program.getLogStream()) {
      print('Program Info: $log');
    }
  }
}