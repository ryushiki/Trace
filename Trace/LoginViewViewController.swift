//
//  LoginViewViewController.swift
//  ConferenceReservation
//
//  Created by liuzhihui on 16/5/21.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit
import Firebase

class LoginViewViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet{
            userNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        guard let email = userNameTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.signedIn(user!)
        })
        
    }
    
    func showAlertController(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)

        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signedIn(user: FIRUser?) {
        
        performSegueWithIdentifier(Constants.Segues.SignInToMain, sender: nil)
    }
    
}
