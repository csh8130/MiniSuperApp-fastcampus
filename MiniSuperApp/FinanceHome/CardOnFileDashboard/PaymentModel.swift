//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by korit on 2021/11/29.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
