//
//  CreateAccountUIView.swift
//  project1-2
//
//  Created by Hunter Bowman on 4/21/20.
//  Copyright © 2020 Hunter Bowman. All rights reserved.
//

import UIKit

class CreateAccountUIView: UIView {
    
    @IBAction func saveButton(_ sender: Any) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //post notification
        NotificationCenter.default.post(name: NSNotification.Name("CAViewCancelButtonHit"), object: nil)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
