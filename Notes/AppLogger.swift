//
//  AppLogger.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import Logging

class AppLogger {
    static func make(logLevel: Logger.Level = .info) -> Logger {
        var logger = Logger(label: "net.yaslab.Notes") { label in
            var handlers: [any LogHandler] = []
            handlers.append(StreamLogHandler.standardOutput(label: label))
            return MultiplexLogHandler(handlers)
        }

        logger.logLevel = logLevel

        return logger
    }
}

extension Logger {
    func trace(file: String = #fileID, line: UInt = #line, function: String = #function) {
        self.trace("\(file):\(line):\(function)")
    }
}
