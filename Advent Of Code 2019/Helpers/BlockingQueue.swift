//
//  BlockingQueue.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 11/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

fileprivate class Node<T>: CustomDebugStringConvertible {
    var debugDescription: String { "\(data)" }

    let data: T
    var next: Node<T>?

    init(data: T) {
        self.data = data
    }
}

struct BlockingQueue<T> {
    let semaphore: DispatchSemaphore
    private var first, last: Node<T>?

    init(_ initialValues: T...) {
        semaphore = DispatchSemaphore(value: 0)
        (first, last) = (nil, nil)
        initialValues.forEach { self.put($0) }
    }

    mutating func put(_ value: T) {
        let node = Node(data: value)
        if let lst = self.last {
            lst.next = node
        }
        if first == nil {
            first = node
        }
        last = node
        semaphore.signal()
    }

    mutating func putAll(_ values: T...) {
        values.forEach { self.put($0) }
    }

    mutating func take() -> T {
        semaphore.wait()
        let data = first!.data
        first = first?.next
        if first == nil {
            last = nil
        }
        return data
    }
}
