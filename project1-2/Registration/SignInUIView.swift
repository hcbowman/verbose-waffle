//
//  CreateAccountView.swift
//  project1
//
//  Created by Hunter Bowman on 4/20/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class SignInUIView: UIView {
    

    @IBAction func goButton(_ sender: Any) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //post notification
        NotificationCenter.default.post(name: NSNotification.Name("SIViewCancelButtonHit"), object: nil)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
