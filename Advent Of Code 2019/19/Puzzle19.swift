//
//  Puzzle19.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 19/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 19: Tractor Beam ---

 Unsure of the state of Santa's ship, you borrowed the tractor beam technology from Triton. Time to test it out.

 When you're safely away from anything else, you activate the tractor beam, but nothing happens. It's hard to tell whether it's working if there's nothing to use it on. Fortunately, your ship's drone system can be configured to deploy a drone to specific coordinates and then check whether it's being pulled. There's even an Intcode program (your puzzle input) that gives you access to the drone system.

 The program uses two input instructions to request the X and Y position to which the drone should be deployed. Negative numbers are invalid and will confuse the drone; all numbers should be zero or positive.

 Then, the program will output whether the drone is stationary (0) or being pulled by something (1). For example, the coordinate X=0, Y=0 is directly in front of the tractor beam emitter, so the drone control program will always report 1 at that location.

 To better understand the tractor beam, it is important to get a good picture of the beam itself. For example, suppose you scan the 10x10 grid of points closest to the emitter:

        X
   0->      9
  0#.........
  |.#........
  v..##......
   ...###....
   ....###...
 Y .....####.
   ......####
   ......####
   .......###
  9........##

 In this example, the number of points affected by the tractor beam in the 10x10 area closest to the emitter is 27.

 However, you'll need to scan a larger area to understand the shape of the beam. How many points are affected by the tractor beam in the 50x50 area closest to the emitter? (For each of X and Y, this will be 0 through 49.)

 */

import Foundation

fileprivate class Position {
    let x, y: Int
    var character: Character

    init(x: Int, y: Int, character: Character = ".") {
        self.x = x
        self.y = y
        self.character = character
    }

    func toPixel() -> (x: Int, y: Int, char: Character) {
        (x: x, y: y, char: character)
    }
}

struct Puzzle19: Puzzle {
    private let input: [Int]

    init() {
        input = InputFileReader.readInput(id: "19", separator: ",").map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
    }

    private func plot(_ positions: [Position]) {
        let canvas = Canvas(pixels: positions.map { $0.toPixel() }, anchor: .topLeft)
        canvas.render()
    }

    func part1() -> String {
        let positions = (0..<50).flatMap { (y) -> [Position] in
            (0..<50).map { (x) -> Position in
                Position(x: x, y: y)
            }
        }

        let computer = IntcodeComputer(intcode: input)

        positions.forEach { (position) in
            computer.reset()
            if case let .output(o) = computer.compute(inputs: position.x, position.y), o == 1 {
                position.character = "#"
            }
        }

        plot(positions)
        return "\(positions.filter { $0.character == "#" }.count)"
    }

    func part2() -> String {
        return ""
    }
}
