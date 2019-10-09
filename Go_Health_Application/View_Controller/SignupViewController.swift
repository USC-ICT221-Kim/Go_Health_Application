//
//  SignupViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 10/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    
    //              Text Field
    ///////////////////////////////////////////////////
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    ///////////////////////////////////////////////////

    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    // Sign Up Button
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(secondTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(singUpButton)

    }
    
    @IBAction func singUpTapped(_ sender: Any) {
    }
    
}
