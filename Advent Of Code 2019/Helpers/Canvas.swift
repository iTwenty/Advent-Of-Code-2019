//
//  Canvas.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 14/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

enum Anchor {
    case topLeft, center
}


typealias Pixel = (x: Int, y: Int, char: Character)

struct Canvas {
    private var canvas: [[Character]]
    private let origin: (x: Int, y: Int)
    private let anchor: Anchor

    private static func findExtremes(pixels: [Pixel]) -> (minX: Int, minY: Int, maxX: Int, maxY: Int) {
        pixels.reduce((0, 0, 0, 0)) { (currentExtremes, current) -> (Int, Int, Int, Int) in
            var minX = currentExtremes.0, minY = currentExtremes.1,
            maxX = currentExtremes.2, maxY = currentExtremes.3
            if current.x > maxX { maxX = current.x }
            if current.y > maxY { maxY = current.y }
            if current.x < minX { minX = current.x }
            if current.y < minY { minY = current.y }
            return (minX, minY, maxX, maxY)
        }
    }

    init(pixels: [Pixel], anchor: Anchor, emptyChar: Character = "_") {
        let extremes = Canvas.findExtremes(pixels: pixels)
        self.canvas = (extremes.minY...extremes.maxY).map { (y) -> [Character] in
            return (extremes.minX...extremes.maxX).map { (_) -> Character in emptyChar }
        }
        self.anchor = anchor
        switch self.anchor {
        case .topLeft: self.origin = (0, 0)
        case .center: self.origin = (abs(extremes.minX), abs(extremes.minY))
        }

        pixels.forEach { (pixel) in
            self.draw(x: pixel.x, y: pixel.y, character: pixel.char)
        }
    }

    func adjusted(x: Int, y: Int) -> (Int, Int) {
        switch self.anchor {
        case .topLeft: return (x, y)
        case .center: return (x + self.origin.x, self.canvas.count - 1 - (y + self.origin.y))
        }
    }

    mutating func draw(x: Int, y: Int, character: Character) {
        let adj: (x: Int, y: Int) = adjusted(x: x, y: y)
        canvas[adj.y][adj.x] = character
    }

    func render() {
        canvas.forEach { (row) in
            let r = row.reduce("") { (string, c) -> String in
                "\(string)\(c) "
            }
            print(r)
        }
    }
}
