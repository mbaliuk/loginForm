//
//  AccountModel.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import Foundation
import RealmSwift

class AccountModel {
    let apiModel = ApiModel()
    let realm = try! Realm()
    
    func saveAccount(data: LoginResponse.LoginResponseData, _ completion: @escaping () -> Void) {
        let accountData = AccountObject()
        accountData.id = 1
        accountData.first_name = data.first_name
        accountData.last_name = data.last_name
        accountData.email = data.email
        
        apiModel.getAvatar(url: data.avatar) { image in
            if let image = image {
                accountData.avatar = true
                self.saveAvatar(image: image)
            }
            
            DispatchQueue.main.async {
                do {
                    try self.realm.write {
                        self.realm.create(AccountObject.self, value: accountData, update: .all)
                    }
                } catch {
                    print("Save account error")
                }
                
                completion()
            }
        }
    }
    
    func getSavedAccount() -> AccountObject? {
        let accountData = realm.objects(AccountObject.self).filter("id == 1").first
        
        return accountData
    }
    
    func saveAvatar(image: UIImage) {
        guard let imageData = image.pngData(), let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        
        do {
            try imageData.write(to: directory.appendingPathComponent("user_avatar.png")!)
        } catch {
            print("Save avatar error")
        }
    }
    
    func getUserAvatar() -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("user_avatar.png").path)
        }
        
        return nil
    }
    
    func accountLogout() {
        do {
            try realm.write {
                let accounts = realm.objects(AccountObject.self)
            realm.delete(accounts)
            }
        }
        catch {
            print("Logout account error")
        }
        
    }
}

class AccountObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatar: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
