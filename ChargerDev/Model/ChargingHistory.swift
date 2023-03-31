//
//  ChargingHistory.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/22.
//

import Foundation

struct Record: Codable {
    var begin_time: String
    var charge_time: Int
    var kwh: String
    var end_time: String
    var stop_reason: Int
    var user: String
}

struct ChargingHistory: Codable {
    var total: Int
    var record: [Record]
}
