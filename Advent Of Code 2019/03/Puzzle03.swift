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

 --- Part Two ---

 It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.

 To do this, calculate the number of steps each wire takes to reach each intersection; choose the intersection where the sum of both wires' steps is lowest. If a wire visits a position on the grid multiple times, use the steps value from the first time it visits that position when calculating the total value of a specific intersection.

 The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered. Again consider the example from above:

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

 In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

 However, the top-right intersection is better: the first wire takes only 8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

 Here are the best steps for the extra examples from above:

     R75,D30,R83,U83,L12,D49,R71,U7,L72
     U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
     R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
     U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps

 What is the fewest combined steps the wires must take to reach an intersection?

 */

fileprivate struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    var manhattanDistance: Int { x + y }
}

fileprivate struct VisitedPoint: Hashable, Equatable {
    let point: Point
    let stepsTakenToVisit: Int

    init(x: Int, y: Int, steps: Int) {
        self.point = Point(x: x, y: y)
        self.stepsTakenToVisit = steps
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
    
    private func points(forWire wire: [Move]) -> Set<VisitedPoint> {
        var points = Set<VisitedPoint>()
        var steps = 0
        var currentX = 0
        var currentY = 0
        wire.forEach { (move) in
            switch move.direction {
            case "R":
                let newX = currentX + move.distance
                ((currentX + 1)...newX).forEach { (x) in
                    steps = steps + 1
                    points.insert(VisitedPoint(x: x, y: currentY, steps: steps))
                }
                currentX = newX
            case "L":
                let newX = currentX - move.distance
                (newX...(currentX)).forEach { (x) in
                    steps = steps + 1
                    points.insert(VisitedPoint(x: x, y: currentY, steps: steps))
                }
                currentX = newX
            case "U":
                let newY = currentY + move.distance
                ((currentY + 1)...newY).forEach { (y) in
                    steps = steps + 1
                    points.insert(VisitedPoint(x: currentX, y: y, steps: steps))
                }
                currentY = newY
            case "D":
                let newY = currentY - move.distance
                (newY...(currentY - 1)).forEach { (y) in
                    steps = steps + 1
                    points.insert(VisitedPoint(x: currentX, y: y, steps: steps))
                }
                currentY = newY
            default:
                fatalError("Invalid direction - \(move.direction)")
            }
        }
        return points
    }
    
    func part1() -> String {
        let firstWirePoints = Set(points(forWire: input[0]).map { $0.point })
        let secondWirePoints = Set(points(forWire: input[1]).map { $0.point })
        let minManhattanDistance = firstWirePoints.intersection(secondWirePoints).min(by: {
            $0.manhattanDistance < $1.manhattanDistance
        })!
        return "\(minManhattanDistance)"
        
    }

    // Incorrect answer. Can't figure out what's wrong :(
    func part2() -> String {
        let firstWireVisitedPoints = points(forWire: input[0])
        let secondWireVisitedPoints = points(forWire: input[1])
        let firstWirePoints = Set(firstWireVisitedPoints.map { $0.point })
        let secondWirePoints = Set(secondWireVisitedPoints.map { $0.point })
        let intersection = firstWirePoints.intersection(secondWirePoints)

        var minimum = Int.max
        for intersectionPoint in intersection {
        let intersectionPoinVisitsByFirstWire = firstWireVisitedPoints.filter { $0.point  == intersectionPoint }
            let intersectionPoinVisitsBySecondWire = secondWireVisitedPoints.filter { $0.point  == intersectionPoint }
            for i in intersectionPoinVisitsByFirstWire {
                for j in intersectionPoinVisitsBySecondWire {
                    let currentStepSum = (i.stepsTakenToVisit + j.stepsTakenToVisit)
                    if currentStepSum < minimum {
                        minimum = currentStepSum
                    }
                }
            }
        }
        
        return "\(minimum)"
    }
}
