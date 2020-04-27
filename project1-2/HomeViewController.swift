//
//  HomeViewController.swift
//  project1-2
//
//  Created by Hunter Bowman on 4/21/20.
//  Copyright © 2020 Hunter Bowman. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        switch segue.identifier {
        case "toHostTableView":
            if let tableViewController: HostTableViewController = segue.destination as? HostTableViewController {
                print("Host")
            }
        case "toSettingsView":
            if let viewController: SettingsViewController = segue.destination as? SettingsViewController {
                print("Settings")
            }
        case "toAboutView":
            if let tableViewController: AboutViewController = segue.destination as? AboutViewController {
                print("About")
            }
        default:
            print("to no where...")
        }
    }
    
    
}
