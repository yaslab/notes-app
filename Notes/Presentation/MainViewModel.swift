//
//  MainViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Foundation
import Observation

@Observable
class MainViewModel {
    // MARK: - States

    var selection: Note.ID? = nil
}
