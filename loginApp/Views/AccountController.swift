//
//  AccountController.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import UIKit

protocol AccountEventsDelegate {
    func accountViewModel_DataCallback(first_name: String, last_name: String, avatar: UIImage?, email: String)
    func accountViewModel_LogoutCallback()
}

class AccountController: UIViewController, AccountEventsDelegate {
    let accountViewModel = AccountViewModel()
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBAction func logoutAction(_ sender: Any) {
        accountViewModel.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        
        accountViewModel.delegate = self
        accountViewModel.loadData()
    }
    
    override func viewDidAppear(_: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func accountViewModel_DataCallback(first_name: String, last_name: String, avatar: UIImage?, email: String) {
        
        nameLabel.text = first_name + " " + last_name
        emailLabel.text = email
        avatarImage.image = avatar
    }
    
    func accountViewModel_LogoutCallback() {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
}
