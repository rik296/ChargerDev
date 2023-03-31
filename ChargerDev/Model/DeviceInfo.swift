//
//  DeviceInfo.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/21.
//

import Foundation

struct DeviceInfo: Codable {
    var sn: String
    var mode: Int
    var timing: Int
    var pe_detect: Int
    var conn_start: Int
    var cd_detect: Int
    var lan: Int
    var total_kwh: String
    var net_set: Int
    var e_v: String
    var e_i: String
    var e_kw: String
    var mac: String
    var iccid: String
    var ac_type: Int
    var icd_hw_ver: String
    var icd_ver: String
    var iot_ver: String
    var func_monitor: Int
    var func_humanface: Int
    var func_groundlock: Int
    var func_card: Int
    var func_conn_start: Int
    var func_pe_detect: Int
    var func_total_kwh: Int
    var func_appointment: Int
    var func_limit_time: Int
    var activ_time: String
    var func_tplug: Int
    var i_opt: String
    var t_opt: String
    var iot_hw_ver: String
    var ocpp_sur: Int
    var func_nfc: Int
    var func_4g: Int
    var func_wifi: Int
    var func_ble: Int
    var use_flag: Int
    var func_share: Int
    var sta_ssid: String
    var sta_psw: String
    var func_reserve: Int
    var r_hour: Int
    var r_min: Int
    var brand: Int
}
