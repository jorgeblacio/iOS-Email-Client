//
//  RemoveDeviceUIPopover.swift
//  iOS-Email-Client
//
//  Created by Pedro Aim on 8/22/18.
//  Copyright © 2018 Criptext Inc. All rights reserved.
//

import Foundation
import Material

class RemoveDeviceUIPopover: BaseUIPopover {
    
    var device: Device!
    var myAccount: Account!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var onSuccess: ((Int) -> Void)?
    
    init(){
        super.init("RemoveDeviceUIPopover")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.detailColor = .alert
        showLoader(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onConfirmPress(_ sender: Any) {
        passwordTextField.detail = ""
        guard let password = passwordTextField.text,
            password.count > 0 else {
                return
        }
        let deviceId = device.id
        showLoader(true)
        APIManager.removeDevice(deviceId: deviceId, token: myAccount.jwt) { (responseData) in
            if case .LoggedOut = responseData,
                let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.logout()
                return
            }
            guard case .Success = responseData else {
                self.showLoader(false)
                self.passwordTextField.detail = "Unable to remove device \(self.device.name)"
                return
            }
            self.onSuccess?(deviceId)
            self.dismiss(animated: true)
        }
    }
    
    func showLoader(_ show: Bool){
        self.shouldDismiss = !show
        passwordTextField.isEnabled = !show
        confirmButton.isEnabled = !show
        cancelButton.isEnabled = !show
        cancelButton.setTitle(show ? "" : "Cancel", for: .normal)
        confirmButton.setTitle(show ? "" : "Confirm", for: .normal)
        loader.isHidden = !show
        guard show else {
            loader.stopAnimating()
            return
        }
        loader.startAnimating()
    }
    
}
