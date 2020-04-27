//
//  SignInViewController.swift
//  project1-2
//
//  Created by Hunter Bowman on 4/21/20.
//  Copyright © 2020 Hunter Bowman. All rights reserved.
//

import UIKit
//import Firebase
//import GoogleSignIn

class LogInViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()

        /*
      GIDSignIn.sharedInstance().uiDelegate = self
      GIDSignIn.sharedInstance().signInSilently()
      handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
        if user != nil {
          MeasurementHelper.sendLoginEvent()
          self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
        }
      }
         */
    }
    

    deinit {
        /*
        if let handle = handle {
        Auth.auth().removeStateDidChangeListener(handle)
      }
    */
    }
 

}
