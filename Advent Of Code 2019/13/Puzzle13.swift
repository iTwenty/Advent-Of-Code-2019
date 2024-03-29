//
//  Puzzle13.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 14/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 13: Care Package ---

 As you ponder the solitude of space and the ever-increasing three-hour roundtrip for messages between you and Earth, you notice that the Space Mail Indicator Light is blinking. To help keep you sane, the Elves have sent you a care package.

 It's a new game for the ship's arcade cabinet! Unfortunately, the arcade is all the way on the other end of the ship. Surely, it won't be hard to build your own - the care package even comes with schematics.

 The arcade cabinet runs Intcode software like the game the Elves sent (your puzzle input). It has a primitive screen capable of drawing square tiles on a grid. The software draws tiles to the screen with output instructions: every three output instructions specify the x position (distance from the left), y position (distance from the top), and tile id. The tile id is interpreted as follows:

 0 is an empty tile. No game object appears in this tile.
 1 is a wall tile. Walls are indestructible barriers.
 2 is a block tile. Blocks can be broken by the ball.
 3 is a horizontal paddle tile. The paddle is indestructible.
 4 is a ball tile. The ball moves diagonally and bounces off objects.

 For example, a sequence of output values like 1,2,3,6,5,4 would draw a horizontal paddle tile (1 tile from the left and 2 tiles from the top) and a ball tile (6 tiles from the left and 5 tiles from the top).

 Start the game. How many block tiles are on the screen when the game exits?

 --- Part Two ---

 The game didn't run because you didn't put in any quarters. Unfortunately, you did not bring any quarters. Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play for free.

 The arcade cabinet has a joystick that can move left and right. The software reads the position of the joystick with input instructions:

     If the joystick is in the neutral position, provide 0.
     If the joystick is tilted to the left, provide -1.
     If the joystick is tilted to the right, provide 1.

 The arcade cabinet also has a segment display capable of showing a single number that represents the player's current score. When three output instructions specify X=-1, Y=0, the third output instruction is not a tile; the value instead specifies the new score to show in the segment display. For example, a sequence of output values like -1,0,12345 would show 12345 as the player's current score.

 Beat the game by breaking all the blocks. What is your score after the last block is broken?

 */

import Foundation

fileprivate enum TileType: Int {
    case empty, wall, block, paddle, ball

    func character() -> Character {
        switch self {
        case .empty: return " "
        case .wall: return "|"
        case .block: return "x"
        case .paddle: return "="
        case .ball: return "o"
        }
    }
}

fileprivate struct Position: Equatable, Hashable {
    let x, y: Int
}

struct Puzzle13: Puzzle {
    private let input: [Int]

    init() {
        input = InputFileReader.readInput(id: "13", separator: ",").map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
    }

    func part1() -> String {
        let game = IntcodeComputer(intcode: input)
        var tiles: [Position: TileType] = [:]
        while case let .output(xPos) = game.compute() {
            guard case let .output(yPos) = game.compute(),
                case let .output(tileTypeRaw) = game.compute()  else {
                    break
            }
            tiles[Position(x: xPos, y: yPos)] = TileType(rawValue: tileTypeRaw)!
        }
        return "\(tiles.values.filter { $0 == .block }.count)"
    }

    private func moveJoystick(tiles: [Position: TileType]) -> Int? {
        guard let ballEntry = tiles.first(where: { (entry) -> Bool in entry.value == .ball }),
            let paddleEntry = tiles.first(where: { (entry) -> Bool in entry.value == .paddle }) else {
            return nil
        }
        if ballEntry.key.x > paddleEntry.key.x {
            return 1
        } else if ballEntry.key.x < paddleEntry.key.x {
            return -1
        } else {
            return 0
        }
    }

    func part2() -> String {
        var inputt = input
        var currentScore = 0
        inputt[0] = 2
        var tiles: [Position: TileType] = [:]
        let game = IntcodeComputer(intcode: inputt) { () -> Int? in
            self.moveJoystick(tiles: tiles)
        }
        var gameEnded = false
        while !gameEnded {
            while case let .output(xPos) = game.compute() {
                guard case let .output(yPos) = game.compute(),
                    case let .output(third) = game.compute()  else {
                        gameEnded = true
                        break
                }
                if xPos == -1, yPos == 0 {
                    currentScore = third
                    gameEnded = true
                } else {
                    tiles[Position(x: xPos, y: yPos)] = TileType(rawValue: third)!
                }
            }
            print(currentScore)
            if gameEnded {
                break
            }
        }
        return ""
    }
}
