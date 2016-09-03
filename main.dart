import 'dart:io';
import 'dart:collection';
import 'dart:async';

const BFOperators = '+-><[],.';

isEveryCodeUnitOperator(String str) => str.codeUnits.every((code) => isCodeUnitOperator(code));
isCodeUnitOperator(int charCode) => BFOperators.codeUnits.any((code) => code == charCode);

enum InstructionType {
  IncrementValue,
  DecrementValue,
  IncrementPointer,
  DecrementPointer,
  JumpBegin,
  JumpEnd,
  ScanByte,
  PrintByte,
}

class ProgramInstruction {
  InstructionType type;
  int data = null;
  ProgramInstruction (String operator, this.data) {
    type = InstructionType.values[BFOperators.indexOf(operator)];
  }
  setData (data) {
    this.data = data;
  }
}

class Program {
  List<ProgramInstruction> instructions;
  Program (String str) {
    assert(isEveryCodeUnitOperator(str));
    strToInst(str);
  }
  strToInst (String str) {
    var beginIndexStack = new Queue<int>();
    instructions = new List<ProgramInstruction>(str.length);
    for (int i = 0; i < str.length; i++) {
      switch (str[i]) {
        case '[':
          beginIndexStack.addLast(i);
          instructions[i] = new ProgramInstruction(str[i], 1);
          break;
        case ']':
          final matchIndex = beginIndexStack.isNotEmpty ? beginIndexStack.last : null;
          beginIndexStack.removeLast();

          instructions[i] = new ProgramInstruction(str[i], matchIndex);
          instructions[matchIndex].setData(i);
          break;
        default:
          instructions[i] = new ProgramInstruction(str[i], 1);
      }
    }
  }

  Stream run () async* {
    var memory = new List<int>()
      ..length = 1
      ..[0] = 0;
    var memoryIndex = 0;
    var instructionIndex = 0;

    while (0 <= instructionIndex && instructionIndex < instructions.length) {
      var instruction = instructions[instructionIndex];
      switch (instruction.type) {
        case InstructionType.IncrementPointer:
          memoryIndex += instruction.data;
          if (memory.length <= memoryIndex) {
            var prev = memory.length;
            memory.length = memoryIndex + 1;
            memory.fillRange(prev, memory.length, 0);
          }
          break;
        case InstructionType.DecrementPointer:
          memoryIndex -= instruction.data;
          break;
        case InstructionType.IncrementValue:
          if (memoryIndex < 0) {
            throw new UnimplementedError();
          }
          memory[memoryIndex] += instruction.data;
          break;
        case InstructionType.DecrementValue:
          if (memoryIndex < 0) {
            throw new UnimplementedError();
          }
          memory[memoryIndex] -= instruction.data;
          break;
        case InstructionType.JumpBegin:
          // FIXME: Currently, negative memory index could be treated as value zero.
          if (memoryIndex < 0 || memory[memoryIndex] == 0) {
            instructionIndex = instruction.data;
          }
          break;
        case InstructionType.JumpEnd:
          // FIXME: Currently, negative memory index could be treated as value zero.
          if (memoryIndex >= 0 && memory[memoryIndex] != 0) {
            instructionIndex = instruction.data;
          }
          break;
        case InstructionType.PrintByte:
          if (memoryIndex < 0) {
            throw new UnimplementedError();
          }
          yield memory[memoryIndex];
          break;
        default:
          throw new UnimplementedError();
      }
      instructionIndex++;
    }
  }
}

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
