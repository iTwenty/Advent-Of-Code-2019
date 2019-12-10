//
//  Puzzle10.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 10/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 10: Monitoring Station ---

 You fly into the asteroid belt and reach the Ceres monitoring station. The Elves here have an emergency: they're having trouble tracking all of the asteroids and can't be sure they're safe.

 The Elves would like to build a new monitoring station in a nearby area of space; they hand you a map of all of the asteroids in that region (your puzzle input).

 The map indicates whether each position is empty (.) or contains an asteroid (#). The asteroids are much smaller than they appear on the map, and every asteroid is exactly in the center of its marked position. The asteroids can be described with X,Y coordinates where X is the distance from the left edge and Y is the distance from the top edge (so the top-left corner is 0,0 and the position immediately to its right is 1,0).

 Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.

 For example, consider the following map:

 .#..#
 .....
 #####
 ....#
 ...##

 The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids, more than any other location. (The only asteroid it cannot detect is the one at 1,0; its view of this asteroid is blocked by the asteroid at 2,2.) All other asteroids are worse locations; they can detect 7 or fewer other asteroids. Here is the number of other asteroids a monitoring station on each asteroid could detect:

 .7..7
 .....
 67775
 ....7
 ...87

 Here is an asteroid (#) and some examples of the ways its line of sight might be blocked. If there were another asteroid at the location of a capital letter, the locations marked with the corresponding lowercase letter would be blocked and could not be detected:

 #.........
 ...A......
 ...B..a...
 .EDCG....a
 ..F.c.b...
 .....c....
 ..efd.c.gb
 .......c..
 ....f...c.
 ...e..d..c

 Here are some larger examples:

     Best is 5,8 with 33 other asteroids detected:

     ......#.#.
     #..#.#....
     ..#######.
     .#.#.###..
     .#..#.....
     ..#....#.#
     #..#....#.
     .##.#..###
     ##...#..#.
     .#....####

     Best is 1,2 with 35 other asteroids detected:

     #.#...#.#.
     .###....#.
     .#....#...
     ##.#.#.#.#
     ....#.#.#.
     .##..###.#
     ..#...##..
     ..##....##
     ......#...
     .####.###.

     Best is 6,3 with 41 other asteroids detected:

     .#..#..###
     ####.###.#
     ....###.#.
     ..###.##.#
     ##.##.#.#.
     ....###..#
     ..#.#..#.#
     #..#.#.###
     .##...##.#
     .....#.#..

     Best is 11,13 with 210 other asteroids detected:

     .#..##.###...#######
     ##.############..##.
     .#.######.########.#
     .###.#######.####.#.
     #####.##.#.##.###.##
     ..#####..#.#########
     ####################
     #.####....###.#.#.##
     ##.#################
     #####.##.###..####..
     ..######..##.#######
     ####.##.####...##..#
     .#####..#.######.###
     ##...#.##########...
     #.##########.#######
     .####.#.###.###.#.##
     ....##.##.###..#####
     .#.#.###########.###
     #.#.#.#####.####.###
     ###.##.####.##.#..##

 Find the best location for a new monitoring station. How many other asteroids can be detected from that location?

 */

import Foundation

fileprivate struct Position: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct Puzzle10: Puzzle {
    private let positions: Set<Position>

    init() {
        let inputLines = InputFileReader.readInput(id: "10")
        positions = Set(inputLines.enumerated().flatMap { (tuple) -> [Position] in
            let (offset, inputLine) = tuple
            return inputLine.enumerated().compactMap { (innerTuple) -> Position? in
                let (innerOffset, element) = innerTuple
                if element == "#" {
                    return Position(x: innerOffset, y: offset)
                }
                return nil
            }
        })
    }

    private func reduced(_ x: Int, _ y: Int) -> (Int, Int) {
        func gcd(_ x: Int, _ y: Int) -> Int {
            if y == 0 {
                return x
            } else {
                return gcd(y, x % y)
            }
        }

        let d = gcd(abs(x), abs(y))
        return (x / d, y / d)
    }

    private func isVisible(_ that: Position, from this: Position) -> Bool {
        let delta = (that.x - this.x, that.y - this.y)
        let reducedDelta = reduced(delta.0, delta.1)

        var current = reducedDelta
        while abs(current.0) <= abs(delta.0), abs(current.1) <= abs(delta.1) {
            if positions.contains(Position(x: this.x + current.0, y: this.y + current.1)) {
                break
            }
            current = (current.0 + reducedDelta.0, current.1 + reducedDelta.1)
        }
        return current == delta
    }

    func part1() -> String {
        var max = 0
        positions.forEach { (this) in
            var currentMax = 0
            positions.forEach { (that) in
                if this != that, isVisible(that, from: this) {
                    currentMax = currentMax + 1
                }
            }
            if currentMax > max {
                max = currentMax
            }
        }
        return "\(max)"
    }

    func part2() -> String {
        print(reduced(-24, 8))
        return ""
    }
}
