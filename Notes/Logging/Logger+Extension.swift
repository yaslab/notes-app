//
//  Logger+Extension.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import Logging

extension Logger {
    func trace(file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.trace("\(file):\(function):L\(line)", file: file, function: function, line: line)
    }
}
