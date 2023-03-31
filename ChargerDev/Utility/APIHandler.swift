//
//  APIHandler.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/17.
//

import Foundation

class APIHandler {
    static let shared = APIHandler()
    private init() {}
    
    private let baseURLString = "http://192.168.4.1/"
    
    func fetchJsonData<T>(from url: String, completion: @escaping (Result<T, Error>) -> Void) where T: Codable{
        HTTPHandler(data: [:], url: url, method: .get, isJSONRequest: false).executeQuery(){
            (result: Result<T, Error>) in
            switch result{
            case .success(let resp):
                print("APIHandler : ", resp)
                completion(.success(resp))
            case .failure(let error):
                print("APIHandler : ", error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchStringData<T>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        HTTPHandler(data: [:], url: url, method: .get, isJSONRequest: false).executeQueryWithoutJSONResp(){
            (result: Result<T, Error>) in
            switch result{
            case .success(let resp):
                print("APIHandler : ", resp)
                completion(.success(resp))
            case .failure(let error):
                print("APIHandler : ", error)
                completion(.failure(error))
            }
        }
    }
    
    func prettyPrintJSON<T: Encodable>(object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(object) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func makeURL(endpoint: Endpoint) -> String? {
        return "\(baseURLString)\(endpoint.path)"
    }
    
    enum Endpoint {
        case param
        case refreshdata
        case control_1(start: Int, mode: Int, timing: Int, reserve: Int, r_hour: Int, r_min: Int)
        case control_2(mode: Int, timing: Int)
        case cdDetect(cd_detect: Int)
        case connStart(conn_start: Int)
        case peDetect(pe_detect: Int)
        case clearKwh
        case psw(psw: String)
        case updateMsg
        case record
        case clearRecord
        case factoryReset
        case reboot
        
        var path: String {
            switch self {
            case .param:
                return "?param"
            case .refreshdata:
                return "?reflashdata"
            case .control_1(let start, let mode, let timing, let reserve, let r_hour, let r_min):
                return "control?start=\(start)&mode=\(mode)&timing=\(timing)&user=U001&reserve=\(reserve)&r_hour=\(r_hour)&r_min=\(r_min)"
            case .control_2(let mode, let timing):
                return "control?start=255&mode=\(mode)&timing=\(timing)"
            case .cdDetect(let cd_detect):
                return "param?cd_detect=\(cd_detect)"
            case .connStart(let conn_start):
                return "param?conn_start=\(conn_start)"
            case .peDetect(let pe_detect):
                return "param?pe_detect=\(pe_detect)"
            case .clearKwh:
                return "param?clear_kwh=1"
            case .psw(let psw):
                return "param?psw=\(psw)"
            case .updateMsg:
                return "update_msg"
            case .record:
                return "?record"
            case .clearRecord:
                return "param?clear_record=1"
            case .factoryReset:
                return "param?factory_reset=1"
            case .reboot:
                return "param?reboot=1"
            }
        }
    }
}
