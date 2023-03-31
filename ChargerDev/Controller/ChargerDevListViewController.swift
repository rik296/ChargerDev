//
//  ChargerDevListViewController.swift
//  ChargerDev
//
//  Created by Rik Tsai on 2023/3/14.
//

import UIKit

class ChargerDevListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var options = ["获取设备信息",
                   "实时数据",
                   "启动/停止充电",
                   "调整电流模式和限充时间",
                   "即插即充设置：off",
                   "无感启充设置：off",
                   "接地检测设置：off",
                   "清除电量",
                   "修改连接密码",
                   "打开升级界面",
                   "获取固件版本及升级信息",
                   "固件上传(升级)",
                   "获取充电记录信息",
                   "清除历史记录",
                   "恢复出厂",
                   "重启模块"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: .zero)
    }

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 处理获取设备信息选项
            let url = APIHandler.shared.makeURL(endpoint: .param)
            APIHandler.shared.fetchJsonData(from: url!) { (result: Result<DeviceInfo, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    let message = APIHandler.shared.prettyPrintJSON(object: data)
                    self.showAlert(message: message!)
                    
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 1:
            // 处理实时数据选项
            let url = APIHandler.shared.makeURL(endpoint: .refreshdata)
            APIHandler.shared.fetchJsonData(from: url!) { (result: Result<RefreshData, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    let message = APIHandler.shared.prettyPrintJSON(object: data)
                    self.showAlert(message: message!)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 2:
            // 处理启动/停止充电选项
            let hint = "S(0/1/255),M(8/10/13/16/22/24/32/40/48),T(0~10),Hour(0~23),Min(0~59)"
            self.showInputTextAlert(hint: hint) { retStr in
                let values = retStr?.split(separator: ",")
                guard values!.count == 5 else {
                    self.showAlert(message: "輸入格式錯誤")
                    return
                }
                
                let countDownSec = self.countDownSeconds(untilHH: Int(values![3])!, untilMM: Int(values![4])!)
                let url = APIHandler.shared.makeURL(endpoint: .control_1(start: Int(values![0])!, mode: Int(values![1])!, timing: Int(values![2])!, reserve: countDownSec!, r_hour: Int(values![3])!, r_min: Int(values![4])!))
                APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                    switch result {
                    case .success(let data):
                        // Handle data
                        self.showAlert(message: data)
                    case .failure(let error):
                        // Handle error
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
            break
            
        case 3:
            // 处理调整电流模式和限充时间选项
            let hint = "M(8/10/13/16/22/24/32/40/48),T(0~10)"
            self.showInputTextAlert(hint: hint) { retStr in
                let values = retStr?.split(separator: ",")
                guard values!.count == 2 else {
                    self.showAlert(message: "輸入格式錯誤")
                    return
                }
                
                let url = APIHandler.shared.makeURL(endpoint: .control_2(mode: Int(values![0])!, timing: Int(values![1])!))
                APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                    switch result {
                    case .success(let data):
                        // Handle data
                        self.showAlert(message: data)
                    case .failure(let error):
                        // Handle error
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
            break
            
        case 4, 5, 6:
            // 处理即插即充设置选项
            // 处理无感启充设置选项
            // 处理接地检测设置选项
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            var inputValue: Int = 0
            let str = cell.textLabel?.text
            if (str!.contains("on")) {
                inputValue = 0
            } else {
                inputValue = 1
            }
            
            var url: String = ""
            if (indexPath.row == 4) {
                url = APIHandler.shared.makeURL(endpoint: .cdDetect(cd_detect: inputValue))!
            }
            else if (indexPath.row == 5) {
                url = APIHandler.shared.makeURL(endpoint: .connStart(conn_start: inputValue))!
            }
            else {
                url = APIHandler.shared.makeURL(endpoint: .peDetect(pe_detect: inputValue))!
            }
            
            APIHandler.shared.fetchStringData(from: url) { (result: Result<String, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    let originalString = cell.textLabel?.text
                    let newString = (inputValue == 1) ? originalString!.replacingOccurrences(of: "off", with: "on") : originalString!.replacingOccurrences(of: "on", with: "off")
                    cell.textLabel?.text = newString
                    self.options[indexPath.row] = newString
                    self.showAlert(message: data)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break

        case 7:
            // 处理清除电量选项
            let url = APIHandler.shared.makeURL(endpoint: .clearKwh)
            APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    self.showAlert(message: data)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 8:
            // 处理修改连接密码选项
            let hint = "修改密碼(輸入8-16位字符)"
            self.showInputTextAlert(hint: hint) { retStr in
                if retStr!.count < 8 || retStr!.count > 16 {
                    self.showAlert(message: "格式錯誤")
                    return
                }
                
                let url = APIHandler.shared.makeURL(endpoint: .psw(psw: retStr!))
                APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                    switch result {
                    case .success(let data):
                        // Handle data
                        self.showAlert(message: data)
                    case .failure(let error):
                        // Handle error
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
            break
            
        case 9:
            // 处理打开升级界面选项
            if let url = URL(string: "http://192.168.4.1/update") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    self.showAlert(message: "Cannot open URL")
                }
            } else {
                self.showAlert(message: "Invalid URL")
            }
            break
            
        case 10:
            // 处理获取固件版本及升级信息选项
            let url = APIHandler.shared.makeURL(endpoint: .updateMsg)
            APIHandler.shared.fetchJsonData(from: url!) { (result: Result<FirmwareUpdateInfo, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    let message = APIHandler.shared.prettyPrintJSON(object: data)
                    self.showAlert(message: message!)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 11:
            // 处理固件上传(升级)选项
            break
            
        case 12:
            // 处理获取充电记录信息选项
            let url = APIHandler.shared.makeURL(endpoint: .record)
            APIHandler.shared.fetchJsonData(from: url!) { (result: Result<ChargingHistory, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    let message = APIHandler.shared.prettyPrintJSON(object: data)
                    self.showAlert(message: message!)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 13:
            // 处理清除历史记录选项
            let url = APIHandler.shared.makeURL(endpoint: .clearRecord)
            APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    self.showAlert(message: data)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 14:
            // 处理恢复出厂选项
            let url = APIHandler.shared.makeURL(endpoint: .factoryReset)
            APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    self.showAlert(message: data)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        case 15:
            // 处理重启模块选项
            let url = APIHandler.shared.makeURL(endpoint: .reboot)
            APIHandler.shared.fetchStringData(from: url!) { (result: Result<String, Error>) in
                switch result {
                case .success(let data):
                    // Handle data
                    self.showAlert(message: data)
                case .failure(let error):
                    // Handle error
                    self.showAlert(message: error.localizedDescription)
                }
            }
            break
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInputTextAlert(hint: String?, completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "輸入數值", message: hint, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = ""
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            completion(text)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func countDownSeconds(untilHH hh: Int, untilMM mm: Int) -> Int? {
        let calendar = Calendar.current
        let now = Date()
        
        var dateComponents = DateComponents()
        dateComponents.hour = hh
        dateComponents.minute = mm
        let targetDate = calendar.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime)!
        
        let seconds = Int(targetDate.timeIntervalSince(now))
        
        if seconds > 0 {
            return seconds
        } else {
            return seconds+86400
        }
    }
}

