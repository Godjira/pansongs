//
//  SaveSongViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/11/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit
import CoreData

class SaveSongViewController: UIViewController {
  
  @IBOutlet weak var nameSongTextField: UITextField!
  @IBOutlet weak var authorsTextView: UITextView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  var song: Song?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nameSongTextField.text = song?.name
    authorsTextView.text = song?.author
    descriptionTextView.text = song?.descriptionSong
    
    let barItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(SaveSongViewController.saveAction))
    navigationItem.rightBarButtonItem = barItem
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func saveAction() {
    if nameSongTextField.text != "" && authorsTextView.text != "" {
      song?.load(with: nameSongTextField.text,
                 author: authorsTextView.text,
                 descriptionSong: descriptionTextView.text,
                 date: Date())
      CoreDataManager.shared.saveContext()
      navigationController?.popToRootViewController(animated: true)
    }
  }
}
