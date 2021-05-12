//
//  AnotherController.swift
//  loginApp
//
//  Created by admin on 12.05.2021.
//

import UIKit

class AnotherController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
