//
//  CreateAccountUIView.swift
//  project1-2
//
//  Created by Hunter Bowman on 4/21/20.
//  Copyright © 2020 Hunter Bowman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountUIView: UIView {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            print(error!)
        } else {
            
            // Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    print("Error creating user")
                } else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(
                        data: ["email":email,
                               "uid": result!.user.uid
                        ]
                    ) { (error) in
                        
                        if error != nil {
                            // Show error message
                            print("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen notification
                    NotificationCenter.default.post(name: NSNotification.Name("CAViewSaveButtonHit"), object: nil)
                    
                }
                
            }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //post notification
        NotificationCenter.default.post(name: NSNotification.Name("CAViewCancelButtonHit"), object: nil)
    }
    
    
    // MARK: - Helper Functions
    
    // Checks and Validates the fields; returns nil if good, error if not good
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            reEnterPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            print("fill in all fields")
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Checks if password format is correct
        if isPasswordValid(cleanedPassword) == false {
            print("Password Needs: at least 3 letters and/or numbers")
        }
        
        let rePassword = reEnterPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Checks if passwords match
        if rePassword != cleanedPassword {
            print("Passwords don't match")
        }
        
        
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z\\d$@$#!%*?&]{3,}$")
        return passwordTest.evaluate(with: password)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
