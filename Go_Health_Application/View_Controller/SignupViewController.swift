//
//  SignupViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 10/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignupViewController: UIViewController {

    
    // Text Field
    @IBOutlet weak var firstUserNameTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

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
        
        Utilities.styleTextField(firstUserNameTextField)
        Utilities.styleTextField(secondTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(singUpButton)

    }
    
    // Check the field if data is valid
    func validateField() -> String?{
        
        // Check all field has filled
        if firstUserNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            secondTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."
            
        }
        
        // Check if password is secure and match
        let securedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(securedPassword) == false {
            // Password is not secure
            return "Please make sure your password is at leaset 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func singUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateField()
        
        if error != nil {
            // There is something wrong with feild
            showErrorMessage(error!)
        }
        else {
            
            // Create Secured version of data
            let firstname = firstUserNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = secondTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)



            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if  err != nil {
                    
                    // There was an error creating the user
                    self.showErrorMessage("Failed to create user")
                }
                else {
                    
                    // Completed to create user
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data:[
                        "first_name": firstname,
                        "last_name": lastname,
                        "uid": result!.user.uid
                    ]) {(error) in
                        
                        if error != nil{
                            // Show error message
                            self.showErrorMessage(" Failed to save user data...")
                        }
                 }
                    
                    // Move to Home
                    self.moveToHome()
                    
            }
        }
    }
}
    func moveToHome(){
        let homeViewController = storyboard?.instantiateViewController (withIdentifier: Constants.Stroyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
