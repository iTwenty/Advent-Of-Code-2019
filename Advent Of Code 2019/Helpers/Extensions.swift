//
//  Extensions.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 16/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

extension Array {
    func cycle() -> UnfoldSequence<Element, Int> {
        return sequence(state: 0) { (index) -> Element? in
            defer { index = index + 1 }
            return self[index % self.count]
        }
    }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { $0.wholeNumberValue }
    }
}
