//
//  LoginViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 10/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        // Hide error label
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        
        Utilities.styleFilledButton(loginButton)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
}
    


