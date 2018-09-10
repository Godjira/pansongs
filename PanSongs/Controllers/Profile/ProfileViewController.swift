//
//  ProfileViewController.swift
//  PanSongs
//
//  Created by Godjira on 9/5/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class ProfileViewController: UIViewController {
  
  @IBOutlet weak var displayNameTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if Auth.auth().currentUser == nil {
      let loginVC = LoginViewController.instance()
      loginVC.modalTransitionStyle = .crossDissolve
      loginVC.modalPresentationStyle = .overCurrentContext
      self.present(loginVC, animated: true)
    } else {
      displayNameTextField.text = Auth.auth().currentUser?.displayName
    }
  }
  
  @IBAction func updateDisplayNameAction(_ sender: Any) {
    if displayNameTextField.text!.count < 6 || displayNameTextField.text!.count > 21 {
      let alert = UIAlertController(title: "Display name", message: "A name must contain 6 to 21 characters.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = displayNameTextField.text
    changeRequest?.commitChanges { (error) in
      if error == nil {
        let alert = UIAlertController(title: "Display name", message: "Display name updated.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func exitProfileAction(_ sender: Any) {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print("Error sign out")
      return
    }
    if Auth.auth().currentUser == nil {
      let loginVC = LoginViewController.instance()
      loginVC.modalTransitionStyle = .crossDissolve
      loginVC.modalPresentationStyle = .overCurrentContext
      self.present(loginVC, animated: true)
    }
  }
}
