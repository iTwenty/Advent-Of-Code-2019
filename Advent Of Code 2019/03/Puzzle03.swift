//
//  Puzzle03.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 03/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

/**
 --- Day 3: Crossed Wires ---

 The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, the fuel management system wasn't completely installed, so that's next on the priority list.

 Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).

 The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port. Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.

 For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:

 ...........
 ...........
 ...........
 ....+----+.
 ....|....|.
 ....|....|.
 ....|....|.
 .........|.
 .o-------+.
 ...........

 Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:

 ...........
 .+-----+...
 .|.....|...
 .|..+--X-+.
 .|..|..|.|.
 .|.-X--+.|.
 .|..|....|.
 .|.......|.
 .o-------+.
 ...........

 These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.

 Here are a few more examples:

     R75,D30,R83,U83,L12,D49,R71,U7,L72
     U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
     R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
     U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135

 What is the Manhattan distance from the central port to the closest intersection?

 */

fileprivate struct Point: Hashable, Comparable, CustomStringConvertible {
    let x: Int
    let y: Int
    var manhattanDistance: Int { x + y }
    var description: String { "\(manhattanDistance)" }

    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.manhattanDistance < rhs.manhattanDistance
    }
}

fileprivate struct Move {
    let direction: Character
    let distance: Int
}

struct Puzzle03: Puzzle {
    private let input: [[Move]]
    
    init() {
        input = InputFileReader.readInput(id: "03").map { (path) -> [Move] in
            let moves = path.split(separator: ",")
            return moves.map { (move) -> Move in
                let direction = move.first!
                let distance = Int(move[move.index(after: move.startIndex)..<move.endIndex])!
                return Move(direction: direction, distance: distance)
            }
        }
    }
    
    private func points(forWire wire: [Move]) -> Set<Point> {
        var points: Set<Point> = []
        var currentPoint = Point(x: 0, y: 0)
        wire.forEach { (move) in
            switch move.direction {
            case "R":
                let newX = currentPoint.x + move.distance
                ((currentPoint.x + 1)...newX).forEach { (x) in
                    points.insert(Point(x: x, y: currentPoint.y))
                }
                currentPoint = Point(x: newX, y: currentPoint.y)
            case "L":
                let newX = currentPoint.x - move.distance
                (newX...(currentPoint.x - 1)).forEach { (x) in
                    points.insert(Point(x: x, y: currentPoint.y))
                }
                currentPoint = Point(x: newX, y: currentPoint.y)
            case "U":
                let newY = currentPoint.y + move.distance
                ((currentPoint.y + 1)...newY).forEach { (y) in
                    points.insert(Point(x: currentPoint.x, y: y))
                }
                currentPoint = Point(x: currentPoint.x, y: newY)
            case "D":
                let newY = currentPoint.y - move.distance
                (newY...(currentPoint.y - 1)).forEach { (y) in
                    points.insert(Point(x: currentPoint.x, y: y))
                }
                currentPoint = Point(x: currentPoint.x, y: newY)
            default:
                fatalError("Invalid direction - \(move.direction)")
            }
        }
        return points
    }
    
    func part1() -> String {
        let firstWirePoints: Set<Point> = points(forWire: input[0])
        let secondWirePoints: Set<Point> = points(forWire: input[1])
        return "\(firstWirePoints.intersection(secondWirePoints).min(by: <)!)"
    }
    
    func part2() -> String {
        return ""
    }
}
