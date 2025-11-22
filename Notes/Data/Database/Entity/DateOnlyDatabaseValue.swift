//
//  DateOnlyDatabaseValue.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/19.
//

struct DateOnlyDatabaseValue: RawRepresentable, Codable {
    let rawValue: String

    nonisolated init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DateOnlyDatabaseValue {
    nonisolated init?(from model: DateOnly?) {
        guard let model else {
            return nil
        }
        self.init(rawValue: model.rawValue)
    }

    nonisolated func toModel() -> DateOnly? {
        return DateOnly(rawValue: rawValue)
    }
}
