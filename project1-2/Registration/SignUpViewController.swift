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

class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    private var isMFAEnabled = false
    
    
    @IBOutlet var createAccountUIView: CreateAccountUIView!
    @IBOutlet var signInUIView: SignInUIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    var effect:UIVisualEffect!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let accessToken = AccessToken.current {
//            // User is logged in, use 'accessToken' here.
//            accessToken.isExpired
//        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //init notification receiver
        NotificationCenter.default.addObserver(self, selector: #selector(caViewWasCancelled), name: NSNotification.Name("CAViewCancelButtonHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(siViewWasCancelled), name: NSNotification.Name("SIViewCancelButtonHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(caViewSaveButtonHit), name: NSNotification.Name("CAViewSaveButtonHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(siViewGoButtonHit), name: NSNotification.Name("SIViewGoButtonHit"), object: nil)
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    
    
    
    // MARK: - Google Stuff
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - Facebook Login Stuff
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
            
            // [START headless_facebook_auth]
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            // [END headless_facebook_auth]
            self.firebaseLogin(credential)
            
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
    
    
//     @IBAction private func logOut() {
//         let loginManager = LoginManager()
//         loginManager.logOut()
//
//         let alertController = UIAlertController(
//             title: "Logout",
//             message: "Logged out."
//         )
//         present(alertController, animated: true, completion: nil)
//     }
     
    
    
//    func handleFBLogin() {
//        LoginManager().logIn(permissions: [.email, .publicProfile], viewController: self, completion: nil)
//        { (result, err) in
//            if err != nil {
//                print("my FB button failed", err)
//                return
//            }
//        }
//        print(result?.token.tokenString)
//    }
    
    
    
    
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
    
    @objc private func caViewSaveButtonHit() {
        print("RegistrationViewController was alerted about caViewSaveButtonHit!")
        animateOutCA()
        transitionToHome()
    }
    @objc private func caViewWasCancelled() {
        print("RegistrationViewController was alerted about caViewWasCancelled!")
        animateOutCA()
    }
    @objc private func siViewWasCancelled() {
        print("RegistrationViewController was alerted about siViewWasCancelled!")
        animateOutSI()
    }
    @objc private func siViewGoButtonHit() {
        print("RegistrationViewController was alerted about siViewGoButtonHit!")
        animateOutSI()
        transitionToHome()
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
    
    // MARK: - General
    func firebaseLogin(_ credential: AuthCredential) {
        
        if let user = Auth.auth().currentUser {
            // [START link_credential]
            user.link(with: credential) { (authResult, error) in
                // [START_EXCLUDE]
                //self.hideSpinner {
                if let error = error {
                    self.showMessagePrompt(error.localizedDescription)
                    return
                }
                //self.tableView.reloadData()
                //}
                // [END_EXCLUDE]
            }
            // [END link_credential]
        } else {
            // [START signin_credential]
            Auth.auth().signIn(with: credential) { (authResult, error) in
                // [START_EXCLUDE silent]
                //self.hideSpinner {
                // [END_EXCLUDE]
                
                if let error = error {
//
//                    let authError = error as NSError
//
//                    if (self.isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
//                        // The user is a multi-factor user. Second factor challenge is required.
//                        let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//                        var displayNameString = ""
//                        for tmpFactorInfo in (resolver.hints) {
//                            displayNameString += tmpFactorInfo.displayName ?? ""
//                            displayNameString += " "
//                        }
//
//                        self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
//                            var selectedHint: PhoneMultiFactorInfo?
//                            for tmpFactorInfo in resolver.hints {
//                                if (displayName == tmpFactorInfo.displayName) {
//                                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                                }
//                            }
//                            PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
//                                if error != nil {
//                                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
//                                } else {
//                                    self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
//                                        let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
//                                        let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
//                                        resolver.resolveSignIn(with: assertion!) { authResult, error in
//                                            if error != nil {
//                                                print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
//                                            } else {
//                                                self.navigationController?.popViewController(animated: true)
//                                            }
//                                        }
//                                    })
//                                }
//                            }
//                        })
//                    } else {
//                        self.showMessagePrompt(error.localizedDescription)
//                        return
//                    }
                    // [START_EXCLUDE]
                    self.showMessagePrompt(error.localizedDescription)
                    // [END_EXCLUDE]
                    return
                }
                // User is signed in
                // [START_EXCLUDE]
                // Merge prevUser and currentUser accounts and data
                // ...
                // [END_EXCLUDE]
                // [START_EXCLUDE silent]
                //}
                // [END_EXCLUDE]
            }
            // [END signin_credential]
        }
    }
    
    func showMessagePrompt(_ message: String) {
        //let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertController: UIAlertController
        
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertContAction: UIAlertAction
        
        
        alertController = UIAlertController(
                title: nil,
                message: message,
                preferredStyle: .actionSheet
        )
        
        alertContAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
                 // Called when user taps outside
        })
        
        alertController.addAction(alertContAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "homeVC") as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }

}
