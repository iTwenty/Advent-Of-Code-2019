//
//  Intcode.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 07/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

class IntcodeComputer {
    private var inputCounter = 0

    @discardableResult
    func compute(program: inout [Int], printOutputs: Bool = false, inputs: Int...) -> [Int] {
        self.inputCounter = 0
        var outputs: [Int] = []
        var pc = 0
        while pc < program.count {
            let instruction = program[pc]
            let opcode = instruction % 100
            switch opcode {
            case 1, 2, 7, 8:
                let fstParam = program[pc + 1]
                let sndParam = program[pc + 2]
                let thdParam = program[pc + 3]
                let fstValue = ((instruction / 100) % 10 == 0 ? program[fstParam] : fstParam)
                let sndValue = ((instruction / 1000) % 10 == 0 ? program[sndParam] : sndParam)
                if opcode == 1 {
                    program[thdParam] = fstValue + sndValue
                } else if opcode == 2 {
                    program[thdParam] = fstValue * sndValue
                } else if opcode == 7 {
                    program[thdParam] = (fstValue < sndValue) ? 1 : 0
                } else {
                    program[thdParam] = (fstValue == sndValue) ? 1 : 0
                }
                pc = pc + 4
            case 3:
                program[program[pc + 1]] = readInput(inputs)
                pc = pc + 2
            case 4:
                let fstParam = program[pc + 1]
                let fstValue = ((instruction / 100) % 10 == 0 ? program[fstParam] : fstParam)
                if printOutputs {
                    print(fstValue)
                }
                outputs.append(fstValue)
                pc = pc + 2
            case 5, 6:
                let fstParam = program[pc + 1]
                let sndParam = program[pc + 2]
                let fstValue = ((instruction / 100) % 10 == 0 ? program[fstParam] : fstParam)
                let sndValue = ((instruction / 1000) % 10 == 0 ? program[sndParam] : sndParam)
                if (opcode == 5 && fstValue != 0) || (opcode == 6 && fstValue == 0) {
                    pc = sndValue
                } else {
                    pc = pc + 3
                }
            case 99:
                pc = program.count
            default:
                fatalError("HALT")
            }
        }
        return outputs
    }

    private func readInput(_ inputs: [Int]) -> Int {
        if inputs.isEmpty {
            print("Input opcode 03 found. Enter an input :")
            return Int(readLine()!)!
        } else {
            let inputToReturn = inputs[inputCounter]
            inputCounter = inputCounter + 1
            return inputToReturn
        }
    }
}
