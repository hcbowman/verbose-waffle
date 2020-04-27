//
//  CreateAccountView.swift
//  project1
//
//  Created by Hunter Bowman on 4/20/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInUIView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func goButton(_ sender: Any) {
        
        // Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            print(error!)
        } else {
            
            // Create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    // Couldn't sign in
                    print(error!.localizedDescription)
                } else {
                    //post notification
                    NotificationCenter.default.post(name: NSNotification.Name("SIViewGoButtonHit"), object: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //post notification
        NotificationCenter.default.post(name: NSNotification.Name("SIViewCancelButtonHit"), object: nil)
    }
    
    
    // MARK: - Helper Functions
    
    // Checks and Validates the fields; returns nil if good, error if not good
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            print("fill in all fields")
        }
        
        return nil
    }
    
}
