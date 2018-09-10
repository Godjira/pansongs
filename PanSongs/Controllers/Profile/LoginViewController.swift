//
//  LoginViewController.swift
//  PanSongs
//
//  Created by Godjira on 9/5/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passTextField: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if Auth.auth().currentUser != nil {
     dismiss(animated: true)
    }
  }
  
  @IBAction func signInAction(_ sender: Any) {
    Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { (user, error) in
      if error != nil {
        // create the alert
        let alert = UIAlertController(title: "Sing In", message: "Email or password is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
      }
      if user != nil {
        DispatchQueue.main.async {
          self.dismiss(animated: true)
        }
      }
    }
  }
  
  @IBAction func signUpAction(_ sender: Any) {
    let signUpVC = SignUpViewController.instance()
    signUpVC.modalTransitionStyle = .crossDissolve
    signUpVC.modalPresentationStyle = .overCurrentContext
    signUpVC.delegate = self
    self.present(signUpVC, animated: true)
  }
}

extension LoginViewController: SignUpDelegate {
  func signUpSuccess() {
    if Auth.auth().currentUser != nil {
      dismiss(animated: true)
    }
  }
}
