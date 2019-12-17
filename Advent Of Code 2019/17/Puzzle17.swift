//
//  Puzzle17.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 17/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 17: Set and Forget ---

 An early warning system detects an incoming solar flare and automatically activates the ship's electromagnetic shield. Unfortunately, this has cut off the Wi-Fi for many small robots that, unaware of the impending danger, are now trapped on exterior scaffolding on the unsafe side of the shield. To rescue them, you'll have to act quickly!

 The only tools at your disposal are some wired cameras and a small vacuum robot currently asleep at its charging station. The video quality is poor, but the vacuum robot has a needlessly bright LED that makes it easy to spot no matter where it is.

 An Intcode program, the Aft Scaffolding Control and Information Interface (ASCII, your puzzle input), provides access to the cameras and the vacuum robot. Currently, because the vacuum robot is asleep, you can only access the cameras.

 Running the ASCII program on your Intcode computer will provide the current view of the scaffolds. This is output, purely coincidentally, as ASCII code: 35 means #, 46 means ., 10 starts a new line of output below the current one, and so on. (Within a line, characters are drawn left-to-right.)

 In the camera output, # represents a scaffold and . represents open space. The vacuum robot is visible as ^, v, <, or > depending on whether it is facing up, down, left, or right respectively. When drawn like this, the vacuum robot is always on a scaffold; if the vacuum robot ever walks off of a scaffold and begins tumbling through space uncontrollably, it will instead be visible as X.

 In general, the scaffold forms a path, but it sometimes loops back onto itself. For example, suppose you can see the following view from the cameras:

 ..#..........
 ..#..........
 #######...###
 #.#...#...#.#
 #############
 ..#...#...#..
 ..#####...^..

 Here, the vacuum robot, ^ is facing up and sitting at one end of the scaffold near the bottom-right of the image. The scaffold continues up, loops across itself several times, and ends at the top-left of the image.

 The first step is to calibrate the cameras by getting the alignment parameters of some well-defined points. Locate all scaffold intersections; for each, its alignment parameter is the distance between its left edge and the left edge of the view multiplied by the distance between its top edge and the top edge of the view. Here, the intersections from the above image are marked O:

 ..#..........
 ..#..........
 ##O####...###
 #.#...#...#.#
 ##O###O###O##
 ..#...#...#..
 ..#####...^..

 For these intersections:

     The top-left intersection is 2 units from the left of the image and 2 units from the top of the image, so its alignment parameter is 2 * 2 = 4.
     The bottom-left intersection is 2 units from the left and 4 units from the top, so its alignment parameter is 2 * 4 = 8.
     The bottom-middle intersection is 6 from the left and 4 from the top, so its alignment parameter is 24.
     The bottom-right intersection's alignment parameter is 40.

 To calibrate the cameras, you need the sum of the alignment parameters. In the above example, this is 76.

 Run your ASCII program. What is the sum of the alignment parameters for the scaffold intersections?

 */

import Foundation

fileprivate struct Position: Equatable, Hashable {
    let x, y: Int

    static let origin = Position(x: 0, y: 0)

    var neighbours: [Position] {
        [Position(x: x + 1, y: y),
         Position(x: x, y: y + 1),
         Position(x: x - 1, y: y),
         Position(x: x, y: y - 1)]
    }

    var alignmentParamter: Int { x * y }
}

struct Puzzle17: Puzzle {
    private let input: [Int]

    init() {
        input = InputFileReader.readInput(id: "17", separator: ",").map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
    }

    private func plot(_ pixels: [Position: Character]) {
        let canvas = Canvas(pixels: pixels.map({ (entry) -> Pixel in
            let (position, character) = entry
            return (x: position.x, y: position.y, char: character)
        }), anchor: .topLeft)
        canvas.render()
    }

    func part1() -> String {
        var pixels: [Position: Character] = [:]
        var currentPosition = Position.origin
        let computer = IntcodeComputer(intcode: input)

        while case let .output(value) = computer.compute() {
            pixels[currentPosition] = Character(UnicodeScalar(value)!)
            if value == 10 {
                currentPosition = Position(x: 0, y: currentPosition.y + 1)
            } else {
                currentPosition = Position(x: currentPosition.x + 1, y: currentPosition.y)
            }
        }

        plot(pixels)

        let ans = pixels.reduce(0) { (currentSum, entry) -> Int in
            let (position, character) = entry
            if character == "#", position.neighbours.allSatisfy({ pixels[$0] == "#" }) {
                return currentSum + position.alignmentParamter
            } else {
                return currentSum
            }
        }
        return "\(ans)"
    }

    func part2() -> String {
        return ""
    }
}
