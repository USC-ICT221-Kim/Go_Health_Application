//
//  LoginViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 10/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(loginButton)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Todo: Valide text field
        
        // Simple version of text feild
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Allow user to access
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
    
            if error != nil{
                // cannot sign in
                self.errorLabel.text = "Cannot sign in..... Please try again"
                self.errorLabel.alpha = 1
            }
            else{
                // Let user to move to the home screen
                let homeViewController = self.storyboard?.instantiateViewController (withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
                   
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
    


