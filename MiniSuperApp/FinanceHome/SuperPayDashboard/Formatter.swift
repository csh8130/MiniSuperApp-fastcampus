//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by korit on 2021/11/21.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
