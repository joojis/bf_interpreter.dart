import 'dart:async';
import 'dart:collection';

const BFOperators = '+-><[],.';

isEveryCodeUnitOperator(String str) =>
    str.codeUnits.every((code) => isCodeUnitOperator(code));
isCodeUnitOperator(int charCode) =>
    BFOperators.codeUnits.any((code) => code == charCode);

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
  ProgramInstruction(String operator, this.data) {
    type = InstructionType.values[BFOperators.indexOf(operator)];
  }
}

const ascii_min = 0, ascii_max = 127;

class Program {
  List<ProgramInstruction> instructions;
  HashSet<String> logs;

  Program(String str) {
    assert(isEveryCodeUnitOperator(str));
    logs = new HashSet<String>();
    strToInst(str);
  }
  strToInst(String str) {
    var beginIndexStack = new Queue<int>();
    instructions = new List<ProgramInstruction>(str.length);
    for (int i = 0; i < str.length; i++) {
      switch (str[i]) {
        case '[':
          beginIndexStack.addLast(i);
          instructions[i] = new ProgramInstruction(str[i], null);
          break;
        case ']':
          final matchIndex =
              beginIndexStack.isNotEmpty ? beginIndexStack.last : null;

          instructions[i] = new ProgramInstruction(str[i], matchIndex);
          if (matchIndex == null) {
            _log("There exists unmatched ']' operator.");
            break;
          }
          instructions[matchIndex].data = i;
          beginIndexStack.removeLast();
          break;
        default:
          instructions[i] = new ProgramInstruction(str[i], 1);
      }
    }

    if (beginIndexStack.length > 0) {
      _log("There exists unmatched '[' operator.");
    }
  }

  _log(String str) {
    if (logs.contains(str)) {
      return;
    }
    logs.add(str);
    // TODO: Instead of print, use stream.
    print("Log: ${str}");
  }

  _error(String msg) {
    _log("ERROR: ${msg}");
    throw new Error();
  }

  Stream run() async* {
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
          if (memoryIndex < 0) {
            _log(
                "The pointer has been moved to non-positive which is not supported. Any reference will occur an error in current implementation.");
          }
          break;
        case InstructionType.IncrementValue:
          if (memoryIndex < 0) {
            _error("IncrementValue at non-positive pointer is not supported.");
          }
          memory[memoryIndex] += instruction.data;
          break;
        case InstructionType.DecrementValue:
          if (memoryIndex < 0) {
            _error("DecrementValue at non-positive pointer is not supported.");
          }
          memory[memoryIndex] -= instruction.data;
          break;
        case InstructionType.JumpBegin:
          if (memoryIndex < 0) {
            _error("Referencing non-positive pointer is not supported.");
          }
          if (memory[memoryIndex] == 0) {
            if (instruction.data == null) {
              _error("Unmatched '[' cannot be evaluated.");
            }
            instructionIndex = instruction.data;
          }
          break;
        case InstructionType.JumpEnd:
          if (memoryIndex < 0) {
            _error("Referencing non-positive pointer is not supported.");
          }
          if (memory[memoryIndex] != 0) {
            if (instruction.data == null) {
              _error("Unmatched ']' cannot be evaluated.");
            }
            instructionIndex = instruction.data;
          }
          break;
        case InstructionType.PrintByte:
          if (memoryIndex < 0) {
            _error("Referencing non-positive pointer is not supported.");
          }
          if (ascii_min <= memory[memoryIndex] &&
              memory[memoryIndex] <= ascii_max) {
            yield memory[memoryIndex];
          } else {
            _error(
                "Print error: ${memory[memoryIndex]} is not in range [$ascii_min, $ascii_max].");
          }
          break;
        default:
          throw new UnimplementedError();
      }
      instructionIndex++;
    }
    _inspectMemory(memory);
  }

  // Test all bytes is in ASCII range.
  _inspectMemory(List<int> memory) {
    int count = 0;
    for (int i = 0; i < memory.length; i++) {
      if (memory[i] < ascii_min || ascii_max < memory[i]) {
        count++;
      }
    }
    _log(
        "Memory Inspection Result - Memory bytes in use: ${memory.length}, Number of non-ascii value in memory: ${count}");
  }
}
