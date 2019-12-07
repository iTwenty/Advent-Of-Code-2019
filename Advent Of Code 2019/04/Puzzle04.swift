//
//  Puzzle04.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 04/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 4: Secure Container ---

 You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

 However, they do remember a few key facts about the password:

     It is a six-digit number.
     The value is within the range given in your puzzle input.
     Two adjacent digits are the same (like 22 in 122345).
     Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

 Other than the range rule, the following are true:

     111111 meets these criteria (double 11, never decreases).
     223450 does not meet these criteria (decreasing pair of digits 50).
     123789 does not meet these criteria (no double).

 How many different passwords within the range given in your puzzle input meet these criteria?

 --- Part Two ---

 An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

 Given this additional criterion, but still ignoring the range rule, the following are now true:

     112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
     123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
     111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).

 How many different passwords within the range given in your puzzle input meet all of the criteria?

 */

import Foundation

fileprivate extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

fileprivate extension Array where Element: Hashable {
    func counted() -> [Element: Int] {
        let ones = repeatElement(1, count: self.count)
        return Dictionary(zip(self, ones), uniquingKeysWith: +)
    }
}

struct Puzzle04: Puzzle {
    let possiblePasswords = Array(123257...647015)

    func part1() -> String {
        let count = possiblePasswords.filter { (number) in
            let digits = number.digits
            return digits.sorted() == digits && digits.counted().count < digits.count
        }.count
        return "\(count)"
    }

    func part2() -> String {
        let count = possiblePasswords.filter { (number) in
            let digits = number.digits
            return digits.sorted() == digits && digits.counted().values.contains(2)
        }.count
        return "\(count)"
    }
}
