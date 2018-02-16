//
//  LoginViewController.swift
//  iOS-Email-Client
//
//  Created by Pedro Aim on 2/2/18.
//  Copyright © 2018 Criptext Inc. All rights reserved.
//

import Foundation
import Material

class NewLoginViewController: UIViewController{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var loginErrorLabel: UILabel!
    var failed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loginButtonInit()
        usernameTextFieldInit()
        
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        toggleLoadingView(false)
        clearErrors()
        checkToEnableDisableLoginButton()
    }
    
    @objc func hideKeyboard(){
        self.usernameTextField.endEditing(true)
    }
    
    func usernameTextFieldInit(){
        usernameTextField.placeholder = "Username"
        usernameTextField.placeholderNormalColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        usernameTextField.textColor = UIColor.white
        usernameTextField.dividerNormalColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
        usernameTextField.dividerActiveColor = UIColor.white
        usernameTextField.placeholderActiveScale = 0
    }
    
    func loginButtonInit(){
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 20
        
        let boldText  = "Sign up"
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.white]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
    
        let normalText = "Not registered? "
        let normalAttrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.white]
        let normalString = NSMutableAttributedString(string:normalText, attributes: normalAttrs)
    
        normalString.append(attributedString)
        signupButton.setAttributedTitle(normalString, for: .normal)
    }
    
    func toggleLoadingView(_ show: Bool){
        if(show){
            loginButton.setTitle("", for: .normal)
            loadingView.isHidden = false
            loadingView.startAnimating()
        }else{
            loginButton.setTitle("Log In", for: .normal)
            loadingView.isHidden = true
            loadingView.stopAnimating()
        }
        checkToEnableDisableLoginButton()
    }
    
    @IBAction func usernameChange(_ sender: Any) {
        checkToEnableDisableLoginButton()
        if(!errorImage.isHidden){
            clearErrors()
        }
    }
    
    func checkToEnableDisableLoginButton(){
        loginButton.isEnabled = !usernameTextField.isEmpty
        if(loginButton.isEnabled && loadingView.isHidden){
            loginButton.alpha = 1.0
        }else{
            loginButton.alpha = 0.5
        }
    }
    
    @IBAction func onLoginPress(_ sender: Any) {
        toggleLoadingView(true)
        if(failed){
            let email = usernameTextField.text! + "@criptext.com"
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "loginwaitview") as! LoginDeviceViewController
            controller.loginData = LoginData(email)
        self.navigationController?.pushViewController(controller, animated: true)
            toggleLoadingView(false)
            clearErrors()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
            self.setLoginError("Username does not exist")
            self.toggleLoadingView(false)
            self.failed = true
        }
        
    }
    
    func setLoginError(_ message: String){
        errorImage.isHidden = false
        loginErrorLabel.isHidden = false
        loginErrorLabel.text = message
    }
    
    func clearErrors(){
        errorImage.isHidden = true
        loginErrorLabel.isHidden = true
    }
}

extension NewLoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
}
