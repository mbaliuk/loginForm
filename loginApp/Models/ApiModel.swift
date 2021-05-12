//
//  ApiModel.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import Foundation
import UIKit

class ApiModel {
    let jsonDecoder = JSONDecoder()
    
    func login(_ completion: @escaping (LoginStatus, LoginResponse.LoginResponseData?) -> Void) {
        let session = URLSession.shared
        let requestUrl = URL(string: "https://reqres.in/api/users/2")!
        
        let task = session.dataTask(with: requestUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(LoginStatus.errorResponse, nil)
                return
            }
            
            if let result = self.decodeLoginResponse(json: data) {
                completion(LoginStatus.success, result)
            }
            else {
                completion(LoginStatus.errorParse, nil)
            }
        }
        
        task.resume()
    }
    
    func decodeLoginResponse(json: Data) -> LoginResponse.LoginResponseData? {
        if let jsonData = try? jsonDecoder.decode(LoginResponse.self, from: json) {
            return jsonData.data
        }
        
        return nil
    }
    
    func getAvatar(url: String, _ completion: @escaping (_ avatar: UIImage?) -> Void) {
        let session = URLSession.shared
        guard let requestUrl = URL(string: url) else { return }
        
        let task = session.dataTask(with: requestUrl) { (data, response, error) in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        task.resume()
    }
}
