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
    
    var textSongTextViewString: String?
    var chordSongTextViewString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(SaveSongViewController.saveAction))
        navigationItem.rightBarButtonItem = barItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveAction() {
        if nameSongTextField.text != "" && authorsTextView.text != "" {
            let appDelegat = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegat.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Song", in: context)
            let song = Song(entity: entity!, insertInto: context)
            
            song.name = nameSongTextField.text
            song.author = authorsTextView.text
            song.descriptionSong = descriptionTextView.text
            song.chordTextView = chordSongTextViewString
            song.textTextView = textSongTextViewString
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
        }
    }
    
}
