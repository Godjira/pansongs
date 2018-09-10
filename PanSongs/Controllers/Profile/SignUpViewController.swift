//
//  SingUpViewController.swift
//  PanSongs
//
//  Created by Godjira on 9/6/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

protocol SignUpDelegate {
  func signUpSuccess()
}

class SignUpViewController: UIViewController {
  
  var handle: AuthStateDidChangeListenerHandle?
  
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passTextField: UITextField!
  @IBOutlet weak var repeatPassTextField: UITextField!
  
  var delegate: SignUpDelegate?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if user != nil {
        // user is signed in
        // go to feature controller
        self.dismiss(animated: true)
      } else {
        // user is not signed in
        // go to login controller
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func signUpAction(_ sender: Any) {
    if repeatPassTextField.text != passTextField.text {
      let alert = UIAlertController(title: "Sing In", message: "Passwords do not coincide.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    if (repeatPassTextField.text?.count)! < 6 ||  (repeatPassTextField.text?.count)! > 21 {
      let alert = UIAlertController(title: "Sing In", message: "A password must contain 6 to 21 characters.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    Auth.auth().createUser(withEmail: emailTextField.text!, password: repeatPassTextField.text!) { (authResult, error) in
      guard let user = authResult?.user else {
        DispatchQueue.main.async {
          let alert = UIAlertController(title: "Sing In", message: "Email or password is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
        return
      }
      DispatchQueue.main.async {
        self.dismiss(animated: true)
        self.delegate?.signUpSuccess()
      }
    }
  }
  
  @IBAction func backAction(_ sender: Any) {
    dismiss(animated: true)
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: true, completion: nil)
    Auth.auth().removeStateDidChangeListener(handle!)
  }
}
