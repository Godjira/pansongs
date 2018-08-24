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
  
  var chordSongTextViewString: NSAttributedString?
  var widthTextView: Float?
  
  var song: Song?
  
  let coreDataManager: CoreDataManager = CoreDataManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if song != nil {
      nameSongTextField.text = song?.name
      authorsTextView.text = song?.author
      descriptionTextView.text = song?.descriptionSong
    }
    let barItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(SaveSongViewController.saveAction))
    navigationItem.rightBarButtonItem = barItem
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func saveAction() {
    if nameSongTextField.text != "" && authorsTextView.text != "" {
      if song != nil {
        song?.name = nameSongTextField.text
        song?.author = authorsTextView.text
        song?.descriptionSong = descriptionTextView.text
        song?.textTextView = chordSongTextViewString!
        coreDataManager.saveContext()
        navigationController?.popToRootViewController(animated: true)
        return
      }
      let newSong = coreDataManager.newSong()
      newSong.name = nameSongTextField.text
      newSong.author = authorsTextView.text
      newSong.descriptionSong = descriptionTextView.text
      newSong.textTextView = chordSongTextViewString!
      newSong.widthTextView = widthTextView!
      newSong.date = Date()
      coreDataManager.saveContext()
      navigationController?.popToRootViewController(animated: true)
    }
  }
}
