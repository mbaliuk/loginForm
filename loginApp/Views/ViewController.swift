//
//  ViewController.swift
//  loginApp
//
//  Created by admin on 11.05.2021.
//

import UIKit

class ViewController: UIViewController, LoginEventsDelegate {

    // --- ViewModels
    
    let loginViewModel = LoginViewModel()
    
    // --- Elements
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLoginLabel: UILabel!
    
    // --- Segue
    
    @IBAction func anotherControllerSegue(_ sender: Any) {
        performSegue(withIdentifier: "anotherControllerSegue", sender: nil)
    }
    
    @IBAction func unwindToThisVC(segue: UIStoryboardSegue) { }
    
    @IBAction func loginFieldInput(_ sender: UITextField) {
        if phoneTextField.text!.count > 9 {
            phoneTextField.deleteBackward()
        }
        
        let phone = phoneTextField.text!
        let password = passwordTextField.text!
                
        let validate = loginViewModel.validateLoginFormat(phone: phone, password: password)
        
        if validate {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
        
    }
    
    @IBAction func validateAuth(_ sender: UIButton) {
        let phone = phoneTextField.text!
        let password = passwordTextField.text!
        
        let validate = loginViewModel.validateLoginData(phone: phone, password: password)
        
        if validate {
            errorLoginLabel.isHidden = true
            loginButton.isEnabled = false
            loginViewModel.login()
        }
        else {
            errorLoginLabel.text = LoginStatus.errorData.getText()
            errorLoginLabel.isHidden = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // --- Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel.delegate = self
        
        // --- close keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // --- padding for password field
        passwordTextField.paddingLeft(15)
    }
    
    override func viewDidAppear(_: Bool) {
        if loginViewModel.alreadyLogged() {
            performSegue(withIdentifier: "accountControllerSegue", sender: nil)
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // --- Callback
    func loginViewModel_LoginCallback(status: LoginStatus) {
        if status == LoginStatus.success {
            errorLoginLabel.isHidden = true
            performSegue(withIdentifier: "accountControllerSegue", sender: nil)
        }
        else {
            errorLoginLabel.text = status.getText()
            errorLoginLabel.isHidden = false
        }
        
        loginButton.isEnabled = true
    }
}


// --- UITextField with prefix
@IBDesignable
class PrefixTextField: UITextField {
    @IBInspectable var fieldPrefix: String = "" {
        didSet {
            let prefixLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 0, height: 0))
            prefixLabel.text = fieldPrefix
            prefixLabel.textColor = UIColor.systemBlue
            prefixLabel.sizeToFit()
            
            let prefixView = UIView(frame: CGRect(x: 0, y: 0, width: prefixLabel.frame.width + 45, height: prefixLabel.frame.height))
            prefixView.addSubview(prefixLabel)
            
            let prefixBorder = CALayer()
            prefixBorder.frame = CGRect(x: prefixView.frame.width - 10, y: 0, width: 1, height: prefixView.frame.height)
            prefixBorder.backgroundColor = UIColor.gray.cgColor
            prefixView.layer.addSublayer(prefixBorder)
            
            self.leftView = prefixView
            self.leftViewMode = .always
        }
    }
}

// --- Main login button with border and activity status
@IBDesignable
class LiveButton: UIButton {
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UIColor.systemBlue
                self.setTitleColor(UIColor.white, for: .normal)
                self.borderWidth = 0
            }
            else {
                self.backgroundColor = .none
                self.setTitleColor(UIColor.lightGray, for: .normal)
                self.borderWidth = 1
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

// --- Extension for UITextField padding
extension UITextField {
    func paddingLeft(_ padding: CGFloat) {
        let prefixView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = prefixView
        self.leftViewMode = .always
    }
}


// --- Bordered UIView
@IBDesignable
class BorderedView: UIView {
    var border: CALayer?
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: border?.backgroundColor ?? UIColor.lightGray.cgColor)
        }
        set {
            border?.backgroundColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderTopWidth: CGFloat = 0 {
        didSet {
            border = CALayer()
            border!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderTopWidth)
            self.layer.addSublayer(border!)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        border?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderTopWidth)
    }
}
