//
//  Puzzle21.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 21/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 21: Springdroid Adventure ---

 You lift off from Pluto and start flying in the direction of Santa.

 While experimenting further with the tractor beam, you accidentally pull an asteroid directly into your ship! It deals significant damage to your hull and causes your ship to begin tumbling violently.

 You can send a droid out to investigate, but the tumbling is causing enough artificial gravity that one wrong step could send the droid through a hole in the hull and flying out into space.

 The clear choice for this mission is a droid that can jump over the holes in the hull - a springdroid.

 You can use an Intcode program (your puzzle input) running on an ASCII-capable computer to program the springdroid. However, springdroids don't run Intcode; instead, they run a simplified assembly language called springscript.

 While a springdroid is certainly capable of navigating the artificial gravity and giant holes, it has one downside: it can only remember at most 15 springscript instructions.

 The springdroid will move forward automatically, constantly thinking about whether to jump. The springscript program defines the logic for this decision.

 Springscript programs only use Boolean values, not numbers or strings. Two registers are available: T, the temporary value register, and J, the jump register. If the jump register is true at the end of the springscript program, the springdroid will try to jump. Both of these registers start with the value false.

 Springdroids have a sensor that can detect whether there is ground at various distances in the direction it is facing; these values are provided in read-only registers. Your springdroid can detect ground at four distances: one tile away (A), two tiles away (B), three tiles away (C), and four tiles away (D). If there is ground at the given distance, the register will be true; if there is a hole, the register will be false.

 There are only three instructions available in springscript:

     AND X Y sets Y to true if both X and Y are true; otherwise, it sets Y to false.
     OR X Y sets Y to true if at least one of X or Y is true; otherwise, it sets Y to false.
     NOT X Y sets Y to true if X is false; otherwise, it sets Y to false.

 In all three instructions, the second argument (Y) needs to be a writable register (either T or J). The first argument (X) can be any register (including A, B, C, or D).

 For example, the one-instruction program NOT A J means "if the tile immediately in front of me is not ground, jump".

 Or, here is a program that jumps if a three-tile-wide hole (with ground on the other side of the hole) is detected:

 NOT A J
 NOT B T
 AND T J
 NOT C T
 AND T J
 AND D J

 The Intcode program expects ASCII inputs and outputs. It will begin by displaying a prompt; then, input the desired instructions one per line. End each line with a newline (ASCII code 10). When you have finished entering your program, provide the command WALK followed by a newline to instruct the springdroid to begin surveying the hull.

 If the springdroid falls into space, an ASCII rendering of the last moments of its life will be produced. In these, @ is the springdroid, # is hull, and . is empty space. For example, suppose you program the springdroid like this:

 NOT D J
 WALK

 This one-instruction program sets J to true if and only if there is no ground four tiles away. In other words, it attempts to jump into any hole it finds:

 .................
 .................
 @................
 #####.###########

 .................
 .................
 .@...............
 #####.###########

 .................
 ..@..............
 .................
 #####.###########

 ...@.............
 .................
 .................
 #####.###########

 .................
 ....@............
 .................
 #####.###########

 .................
 .................
 .....@...........
 #####.###########

 .................
 .................
 .................
 #####@###########

 However, if the springdroid successfully makes it across, it will use an output instruction to indicate the amount of damage to the hull as a single giant integer outside the normal ASCII range.

 Program the springdroid with logic that allows it to survey the hull without falling into space. What amount of hull damage does it report?

 */

import Foundation

enum Register: String {
    case A, B, C, D, E, F, G, H, I, J, T
}

enum Instruction {
    case not(Register, Register)
    case and(Register, Register)
    case or(Register, Register)
    case walk
    case run

    var string: String {
        switch self {
        case .not(let fst, let snd): return "NOT \(fst) \(snd)\n"
        case .and(let fst, let snd): return "AND \(fst) \(snd)\n"
        case .or(let fst, let snd): return "OR \(fst) \(snd)\n"
        case .walk: return "WALK\n"
        case .run: return "RUN\n"
        }
    }

    var ascii: [Int] {
        self.string.map { Int($0.asciiValue!) }
    }
}

struct Puzzle21: Puzzle {
    private let input: [Int]

    init() {
        input = InputFileReader.readInput(id: "21", separator: ",").map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
    }

    // For both parts, the robot jumps 4 spaces
    func part1() -> String {
        // !A || !B || !C && D
        // i.e If hole in any of next three tiles, but 4th is safe to land, jump
        let inputs: [Instruction] = [.not(.A, .J),
                                     .not(.B, .T),
                                     .or(.T, .J),
                                     .not(.C, .T),
                                     .or(.T, .J),
                                     .and(.D, .J),
                                     .walk]
        let computer = IntcodeComputer(intcode: input)
        var outputs: String = ""
        var others: [Int] = []
        while case  let .output(o) = computer.compute(inputs: inputs.flatMap { $0.ascii }) {
            if let ascii = Unicode.Scalar(o) {
                outputs.append(Character(ascii))
            } else {
                others.append(o)
            }
        }
        print(inputs.map { $0.string }.joined())
        print(outputs)
        print(others)
        return ""
    }

    func part2() -> String {
        // Same as P1, but with added condition that only jump if after landing (4 spaces away), it should either be
        // able to walk to next tile (E), or, if forced to jump, the tile it lands on (H) should be ground
        // !A || !B || !C && D && (E || H)
        let inputs: [Instruction] = [.not(.A, .J),
                                     .not(.B, .T),
                                     .or(.T, .J),
                                     .not(.C, .T),
                                     .or(.T, .J),
                                     .and(.D, .J),
                                     .not(.E, .T),
                                     .not(.T, .T),
                                     .or(.H, .T),
                                     .and(.T, .J),
                                     .run]
        let computer = IntcodeComputer(intcode: input)
        var outputs: String = ""
        var others: [Int] = []
        while case  let .output(o) = computer.compute(inputs: inputs.flatMap { $0.ascii }) {
            if let ascii = Unicode.Scalar(o) {
                outputs.append(Character(ascii))
            } else {
                others.append(o)
            }
        }
        print(inputs.map { $0.string }.joined())
        print(outputs)
        print(others)
        return ""
    }
}
