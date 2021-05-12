//
//  LoginViewModel.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import Foundation
import RealmSwift

enum LoginStatus: String {
    case success = "Авторизация прошла успешно"
    case errorResponse = "Не удалось получить ответ от сервера авторизации"
    case errorParse = "Ошибка парсинга ответа сервера авторизации"
    case errorData = "Похоже, вы неверно указали номер телефона или пароль"
    
    func getText() -> String {
        return self.rawValue
    }
}

protocol LoginEventsDelegate {
    func loginViewModel_LoginCallback(status: LoginStatus)
}

class LoginViewModel {
    let apiModel = ApiModel()
    let accountModel = AccountModel()
    
    var delegate: LoginEventsDelegate?
    
    func validateLoginFormat(phone: String, password: String) -> Bool {        
        if phone.count == 9 && phone.isNumeric && password.count >= 4 {
            return true
        }
        
        return false
    }
    
    func login() {
        apiModel.login({ status, response in
            switch status {
            case .success:
                self.accountModel.saveAccount(data: response!) {
                    DispatchQueue.main.async {
                        self.delegate?.loginViewModel_LoginCallback(status: status)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self.delegate?.loginViewModel_LoginCallback(status: status)
                }
            }
        })
    }
    
    func validateLoginData(phone: String, password: String) -> Bool {
        if phone == "961235555" && password == "test" {
            return true
        }
        
        return false
    }
    
    func alreadyLogged() -> Bool {
        if accountModel.getSavedAccount() != nil {
            return true
        }
        
        return false
    }
}

struct LoginResponse: Codable {
    var data: LoginResponseData
    
    struct LoginResponseData: Codable {
        var id: Int
        var email: String
        var first_name: String
        var last_name: String
        var avatar: String
    }
}

extension String {
    var isNumeric: Bool {
        if self.count == 0 { return false }
        
        let digits: Set<Character> = ["0", "1" , "2" , "3", "4", "5", "6", "7", "8", "9"];
        
        return Set(self).isSubset(of: digits)
        
    }
}
