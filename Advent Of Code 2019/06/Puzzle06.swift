//
//  Puzzle06.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 06/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

/**
 --- Day 6: Universal Orbit Map ---

 You've landed at the Universal Orbit Map facility on Mercury. Because navigation in space often involves transferring between orbits, the orbit maps here are useful for finding efficient routes between, for example, you and Santa. You download a map of the local orbits (your puzzle input).

 Except for the universal Center of Mass (COM), every object in space is in orbit around exactly one other object. An orbit looks roughly like this:

                   \
                    \
                     |
                     |
 AAA--> o            o <--BBB
                     |
                     |
                    /
                   /

 In this diagram, the object BBB is in orbit around AAA. The path that BBB takes around AAA (drawn with lines) is only partly shown. In the map data, this orbital relationship is written AAA)BBB, which means "BBB is in orbit around AAA".

 Before you use your map data to plot a course, you need to make sure it wasn't corrupted during the download. To verify maps, the Universal Orbit Map facility uses orbit count checksums - the total number of direct orbits (like the one shown above) and indirect orbits.

 Whenever A orbits B and B orbits C, then A indirectly orbits C. This chain can be any number of objects long: if A orbits B, B orbits C, and C orbits D, then A indirectly orbits D.

 For example, suppose you have the following map:

 COM)B
 B)C
 C)D
 D)E
 E)F
 B)G
 G)H
 D)I
 E)J
 J)K
 K)L

 Visually, the above map of orbits looks like this:

         G - H       J - K - L
        /           /
 COM - B - C - D - E - F
                \
                 I

 In this visual representation, when two objects are connected by a line, the one on the right directly orbits the one on the left.

 Here, we can count the total number of orbits as follows:

     D directly orbits C and indirectly orbits B and COM, a total of 3 orbits.
     L directly orbits K and indirectly orbits J, E, D, C, B, and COM, a total of 7 orbits.
     COM orbits nothing.

 The total number of direct and indirect orbits in this example is 42.

 What is the total number of direct and indirect orbits in your map data?

 */

import Foundation

class Node {
    init(id: String, parent: Node? = nil, children: [Node] = []) {
        self.id = id
        self.parent = parent
        self.children = children
    }

    let id: String
    var parent: Node?
    var children: [Node]
}

class TreeCreator {
    private struct Relation: Equatable, Hashable {
        let parent: String
        let child: String
    }

    fileprivate static func createTree() -> Node {
        let input: Set<Relation> = Set(InputFileReader.readInput(id: "06").map { s in
            let ss = s.split(separator: ")")
            return Relation(parent: String(ss[0]), child: String(ss[1]))
        })
        let childrenLookupDict = Dictionary(grouping: input) { $0.parent }.mapValues { $0.map { $0.child } }
        let parents = Set(input.map { $0.parent })
        let children = Set(input.map { $0.child })
        let roots = parents.subtracting(children)
        return trees(from: Array(roots), childrenLookupDict: childrenLookupDict)[0]
    }

    private static func trees(from roots: [String], childrenLookupDict: [String: [String]]) -> [Node] {
        return roots.map { (root) -> Node in
            let node = Node(id: root)
            node.children = findChildren(of: node, in: childrenLookupDict)
            return node
        }
    }

    private static func findChildren(of parent: Node, in children: [String: [String]]) -> [Node] {
        if let childrenOfParent = children[parent.id] {
            return childrenOfParent.map { (childOfParent) -> Node in
                let node = Node(id: childOfParent, parent: parent)
                node.children = findChildren(of: node, in: children)
                return node
            }
        } else {
            return []
        }
    }
}

struct Puzzle06: Puzzle {
    let tree: Node = TreeCreator.createTree()

    private func depth(ofNode node: Node) -> Int {
        var depth = 0
        var currentParent = node.parent
        while currentParent != nil {
            depth = depth + 1
            currentParent = currentParent?.parent
        }
        return depth
    }

    private func visitTree(_ node: Node, operation: (Node) -> ()) {
        operation(node)
        node.children.forEach { (child) in
            visitTree(child, operation: operation)
        }
    }

    func part1() -> String {
        var totalDepth = 0
        visitTree(tree) { (node) in
            totalDepth = totalDepth + depth(ofNode: node)
        }
        return "\(totalDepth)"
    }

    func part2() -> String {
        return ""
    }
}
