//
//  LoginViewController.swift
//  BuildWeek2
//
//  Created by Clean Mac on 6/22/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case SIgnIn
}


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
    }
    

}
