//
//  FirmwareUpdateInfo.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/22.
//

import Foundation

struct FirmwareUpdateInfo: Codable {
    var type: Int
    var boot: Int
    var icd_version: String
    var wifi_version: String
    var err: Int
    var progress: Int
}
