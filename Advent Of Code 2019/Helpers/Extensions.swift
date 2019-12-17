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
}

extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { $0.wholeNumberValue }
    }
}
