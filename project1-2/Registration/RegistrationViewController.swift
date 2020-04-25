//
//  RegistrationViewController.swift
//  project1
//
//  Created by Hunter Bowman on 4/20/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import GoogleSignIn

class RegistrationViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    
    @IBOutlet var createAccountUIView: CreateAccountUIView!
    @IBOutlet var signInUIView: SignInUIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    var effect:UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
        }
        
        //init notification receiver
        NotificationCenter.default.addObserver(self, selector: #selector(caViewWasCancelled), name: NSNotification.Name("CAViewCancelButtonHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(siViewWasCancelled), name: NSNotification.Name("SIViewCancelButtonHit"), object: nil)
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    
    
    
    // MARK: - Google Stuff
    @IBAction func signInGoogle(_ sender: Any) {
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
    
    
    // MARK: - Facebook Login Stuff
    
    /*
    // Protocall stuff
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        print("Successful Login")
        GraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
            
            if error != nil {
                print(error!)
                return
            }
            
            print(result!)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of FB!")
    }
    */
    
    @IBAction func signInFB(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.email],
            viewController: self)
        { result in
            self.loginManagerDidComplete(result)
        }
        
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(
                title: "Login Cancelled",
                message: "User cancelled login.", preferredStyle: .actionSheet
            )

        case .failed(let error):
            alertController = UIAlertController(
                title: "Login Fail",
                message: "Login failed with error \(error)", preferredStyle: .alert
            )

        case .success(let grantedPermissions, _, _):
            alertController = UIAlertController(
                title: "Login Success",
                message: "Login succeeded with granted permissions:\n\(grantedPermissions)", preferredStyle: .alert
            )
        }
        self.present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
                 // Called when user taps outside
        }))
        
    }
    
    /*
     @IBAction private func logOut() {
         let loginManager = LoginManager()
         loginManager.logOut()

         let alertController = UIAlertController(
             title: "Logout",
             message: "Logged out."
         )
         present(alertController, animated: true, completion: nil)
     }
     */
    
    /*
    func handleFBLogin() {
        LoginManager().logIn(permissions: [.email, .publicProfile], viewController: self, completion: nil)
        { (result, err) in
            if err != nil {
                print("my FB button failed", err)
                return
            }
        }
        print(result?.token.tokenString)
    }
    */
    
    
    
    // MARK: - Manual Sign in Junk
    // TODO: Needs to be cleaned up alot
    @IBAction func createAccount(_ sender: Any) {
        animateInCA()
    }
    @IBAction func signIn(_ sender: Any) {
        animateInSI()
    }
    
    func animateInCA() {
        self.view.addSubview(createAccountUIView)
        createAccountUIView.center = self.view.center
        createAccountUIView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        createAccountUIView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.createAccountUIView.alpha = 1
            self.createAccountUIView.transform = CGAffineTransform.identity
        }
    }
    func animateInSI() {
        self.view.addSubview(signInUIView)
        signInUIView.center = self.view.center
        signInUIView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        signInUIView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.signInUIView.alpha = 1
            self.signInUIView.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func caViewWasCancelled() {
        print("RegistrationViewController was alerted about cancelButtonHit!")
        animateOutCA()
    }
    @objc private func siViewWasCancelled() {
        print("RegistrationViewController was alerted about cancelButtonHit!")
        animateOutSI()
    }
    
    func animateOutCA() {
        UIView.animate(withDuration: 0.3, animations: {
            self.createAccountUIView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.createAccountUIView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.createAccountUIView.removeFromSuperview()
        }
    }
    func animateOutSI() {
        UIView.animate(withDuration: 0.3, animations: {
            self.signInUIView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.signInUIView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.signInUIView.removeFromSuperview()
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
