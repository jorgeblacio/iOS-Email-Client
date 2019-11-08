//
//  CriptextProPopover.swift
//  iOS-Email-Client
//
//  Created by Jorge Blacio on 11/8/19.
//  Copyright © 2019 Criptext Inc. All rights reserved.
//

import Foundation
import Material

class CriptextProPopover: BaseUIPopover {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var fixedMessageLabel: UILabel!
    @IBOutlet weak var getProButton: UIButton!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBOutlet weak var proImageView: UIImageView!
    
    var featureMessage: String? = nil
    var featureImage: UIImage? = nil
    var onGetPro: (() -> Void)?
    
    var theme: Theme {
        return ThemeManager.shared.theme
    }
    
    init(){
        super.init("CriptextProPopover")
        self.shouldDismiss = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let message = featureMessage {
            messageLabel.text = message
        }
        if let image = featureImage {
            proImageView.image = image
        }
        getProButton.setTitle(String.localize("YOU_NEED_PRO_BUTTON"), for: .normal)
        noThanksButton.setTitle(String.localize("YOU_NEED_PRO_NO_THANKS"), for: .normal)
        fixedMessageLabel.text = String.localize("YOU_NEED_PRO_MESSAGE_FIXED")
        applyTheme()
    }
    
    func applyTheme() {
        titleLabel.textColor = theme.markedText
        proImageView .tintColor = theme.criptextBlue
        getProButton.setTitleColor(Color.white, for: .normal)
        noThanksButton.setTitleColor(theme.criptextBlue, for: .normal)
        messageLabel.textColor = theme.secondText
        fixedMessageLabel.textColor = theme.secondText
        
        view.backgroundColor = theme.overallBackground
    }
    
    @IBAction func onOkPress(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onGetPro?()
        }
    }
    @IBAction func onCancelPress(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
