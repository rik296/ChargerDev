//
//  RefreshData.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/21.
//

import Foundation

struct RefreshData: Codable {
    var state: Int
    var v_a: String
    var v_b: String
    var v_c: String
    var i_a: String
    var i_b: String
    var i_c: String
    var power: String
    var kwh: String
    var charge_time: Int
    var fault: Int
    var tbox: Int
    var tplug: Int
    var cd_detect: Int
    var conn_start: Int
    var reserve: Int
    var r_countdown: String
    var net_sta: Int
    var rssi: Int
}
