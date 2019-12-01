//
//  InputFileReader.swift
//  Advent Of Code 2019
//
//  Created by jaydeep on 01/12/19.
//  Copyright © 2019 jaydeep. All rights reserved.
//

import Foundation

class InputFileReader {
    static func readInput(id: String) -> [String] {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleUrl = URL(fileURLWithPath: "InputFilesBundle.bundle", relativeTo: currentDirectoryURL)
        let bundle = Bundle(url: bundleUrl)
        let inputFileUrl = bundle!.url(forResource: "Input\(id)", withExtension: nil)!
        let contents = try! String(contentsOf: inputFileUrl, encoding: .utf8)
        var input: [String] = []
        contents.enumerateLines { (line, stop) in
            input.append(line)
        }
        return input
    }
}
