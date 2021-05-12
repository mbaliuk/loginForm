//
//  AccountViewModel.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import Foundation
import RealmSwift

class AccountViewModel {
    var delegate: AccountEventsDelegate?
    
    let accountModel = AccountModel()
    
    func loadData() {
        guard let account = accountModel.getSavedAccount() else { return }

        var avatar: UIImage?
        
        if account.avatar {
            avatar = accountModel.getUserAvatar()
        }
        
        delegate?.accountViewModel_DataCallback(first_name: account.first_name, last_name: account.last_name, avatar: avatar, email: account.email)
    }
    
    func logout() {
        accountModel.accountLogout()
        
        delegate?.accountViewModel_LogoutCallback()
    }
    
    
}
