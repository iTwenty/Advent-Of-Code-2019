//
//  Intcode.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 07/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

fileprivate enum ParameterMode: Int {
    case position
    case immediate
    case relative
}

enum ExitReason {
    case output(Int)
    case halt
}

class IntcodeComputer {
    // Original program
    private let intcode: [Int]
    private let inputBlock: (() -> Int?)?

    // Internal state
    private var inputCounter = 0
    private var relativeBase = 0
    private var pc = 0
    private var memory: [Int: Int] = [:]

    init(intcode: [Int], inputBlock: (() -> Int?)? = nil) {
        self.intcode = intcode
        self.inputBlock = inputBlock
        reset()
    }

    // Reset the internal state
    func reset() {
        relativeBase = 0
        pc = 0
        memory = [:]
        intcode.enumerated().forEach { (tuple) in
            let (offset, element) = tuple
            memory[offset] = element
        }
    }

    @discardableResult
    func compute(printOutputs: Bool = false, inputs: Int...) -> ExitReason {
        return compute(printOutputs: printOutputs, inputs: inputs)
    }

    @discardableResult
    func compute(printOutputs: Bool = false, inputs: [Int]) -> ExitReason {
        inputCounter = 0
        while true {
            if pc >= intcode.count {
                fatalError("Program counter outside program!!!")
            }
            let instruction = memory[pc, default: 0]
            let opcode = instruction % 100
            switch opcode {
            case 1, 2, 7, 8:
                let fstParam = memory[pc + 1, default: 0]
                let sndParam = memory[pc + 2, default: 0]
                let thdParam = memory[pc + 3, default: 0]
                let fstValue = resolveParameter(fstParam, forMode: (instruction / 100) % 10, program: memory)
                let sndValue = resolveParameter(sndParam, forMode: (instruction / 1000) % 10, program: memory)
                let thdValue = resolveWriteParameter(thdParam, forMode: (instruction / 10000) % 10, program: memory)
                if opcode == 1 {
                    memory[thdValue] = fstValue + sndValue
                } else if opcode == 2 {
                    memory[thdValue] = fstValue * sndValue
                } else if opcode == 7 {
                    memory[thdValue] = (fstValue < sndValue) ? 1 : 0
                } else {
                    memory[thdValue] = (fstValue == sndValue) ? 1 : 0
                }
                pc = pc + 4
            case 3:
                let fstParam = memory[pc + 1, default: 0]
                let fstValue = resolveWriteParameter(fstParam, forMode: (instruction / 100) % 10, program: memory)
                memory[fstValue] = readInput(inputs)
                pc = pc + 2
            case 4:
                let fstParam = memory[pc + 1, default: 0]
                let fstValue = resolveParameter(fstParam, forMode: (instruction / 100) % 10, program: memory)
                if printOutputs {
                    print(fstValue)
                }
                pc = pc + 2
                return .output(fstValue)
            case 5, 6:
                let fstParam = memory[pc + 1, default: 0]
                let sndParam = memory[pc + 2, default: 0]
                let fstValue = resolveParameter(fstParam, forMode: (instruction / 100) % 10, program: memory)
                let sndValue = resolveParameter(sndParam, forMode: (instruction / 1000) % 10, program: memory)
                if (opcode == 5 && fstValue != 0) || (opcode == 6 && fstValue == 0) {
                    pc = sndValue
                } else {
                    pc = pc + 3
                }
            case 9:
                let fstParam = memory[pc + 1, default: 0]
                let fstValue = resolveParameter(fstParam, forMode: (instruction / 100) % 10, program: memory)
                relativeBase += fstValue
                pc = pc + 2
            case 99:
                return .halt
            default:
                fatalError("Invalid opcode - \(opcode)")
            }
        }
    }

    func value(atMemoryAddress address: Int) -> Int {
        return memory[address, default: 0]
    }

    private func resolveParameter(_ parameter: Int, forMode mode: Int, program: [Int: Int]) -> Int {
        guard let parameterMode = ParameterMode(rawValue: mode) else {
            fatalError("Invalid paramater mode : \(mode)")
        }
        switch parameterMode {
        case .position: return program[parameter, default: 0]
        case .immediate: return parameter
        case .relative: return program[relativeBase + parameter, default: 0]
        }
    }

    private func resolveWriteParameter(_ parameter: Int, forMode mode: Int, program: [Int: Int]) -> Int {
        guard let parameterMode = ParameterMode(rawValue: mode) else {
            fatalError("Invalid paramater mode : \(mode)")
        }
        switch parameterMode {
        case .position: return parameter
        case .relative: return relativeBase + parameter
        case .immediate: fatalError("Parameter \(parameter) does not support writing")
        }
    }

    private func readInput(_ inputs: [Int]) -> Int {
        if let input = inputBlock?() {
            return input
        }
        if inputs.indices.contains(self.inputCounter) {
            let inputToReturn = inputs[inputCounter]
            inputCounter = inputCounter + 1
            return inputToReturn
        }  else {
            print("Input opcode 03 found. Enter an input :")
            return Int(readLine()!)!
        }
    }
}
