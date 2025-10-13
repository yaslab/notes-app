//
//  OSLogHandler.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import Foundation
import Logging
import os.log

struct OSLogHandler: LogHandler {
    private let label: String
    var logLevel: Logging.Logger.Level = .info
    var metadata: Logging.Logger.Metadata = [:]

    init(label: String) {
        self.label = label
    }

    func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata explicitMetadata: Logging.Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let levelString = level.rawValue.uppercased()

        // Merge handler metadata with message metadata
        let combinedMetadata = OSLogHandler.prepareMetadata(
            base: self.metadata,
            explicit: metadata
        )

        // Format metadata
        let metadataString = combinedMetadata.map { "\($0.key)=\($0.value)" }.joined(separator: ",")

        // Create log line and print to console
        let logLine = "\(timestamp) \(levelString) [\(metadataString)]: \(message)"

        let logger = os.Logger(subsystem: label, category: file)

        switch level {
        case .trace:
            logger.trace("\(logLine)")
        case .debug:
            logger.debug("\(logLine)")
        case .info:
            logger.info("\(logLine)")
        case .notice:
            logger.notice("\(logLine)")
        case .warning:
            logger.warning("\(logLine)")
        case .error:
            logger.error("\(logLine)")
        case .critical:
            logger.critical("\(logLine)")
        }
    }

    subscript(metadataKey key: String) -> Logging.Logger.MetadataValue? {
        get {
            return self.metadata[key]
        }
        set {
            self.metadata[key] = newValue
        }
    }

    static func prepareMetadata(
        base: Logging.Logger.Metadata,
        explicit: Logging.Logger.Metadata?
    ) -> Logging.Logger.Metadata {
        var metadata = base

        guard let explicit else {
            // all per-log-statement values are empty
            return metadata
        }

        metadata.merge(explicit, uniquingKeysWith: { _, explicit in explicit })

        return metadata
    }
}
