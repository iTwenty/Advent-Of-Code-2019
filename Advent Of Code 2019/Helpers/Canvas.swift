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

struct Canvas {
    private var canvas: [[Character]]
    private let origin: (x: Int, y: Int)
    private let anchor: Anchor

    init(xSize: Int, ySize: Int, start: Character = "_") {
        self.canvas = (0...ySize).map { (y) -> [Character] in
            return (0...xSize).map { (_) -> Character in start }
        }
        self.anchor = .topLeft
        self.origin = (0, 0)
    }

    init(maxX: Int, maxY: Int, minX: Int, minY: Int, start: Character = "_") {
        self.canvas = (minY...maxY).map { (y) -> [Character] in
            return (minX...maxX).map { (_) -> Character in start }
        }
        self.anchor = .center
        self.origin = (abs(minX), abs(minY))
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
        canvas.forEach { print(String($0)) }
    }
}
