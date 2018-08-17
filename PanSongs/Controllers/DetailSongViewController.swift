//
//  DetailSongViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/16/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class DetailSongViewController: UIViewController {
    
    @IBOutlet weak var textView: ChordTextView!
    @IBOutlet weak var chordView: UIView!
    @IBOutlet weak var chordLabel: UILabel!
    
    var chordChordView: Chord?
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEditButton()
        textView.isEditable = false
        textView.isSelectable = true
        
        textView.delegatChordTextView = self
        textView.delegate = textView
        
        textView.attributedText = song?.textTextView
        
        chordView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailSongViewController.tapOnChordLabel))
        chordLabel.addGestureRecognizer(tapGesture)
    }
    
    func initEditButton () {
        let imageView = UIImageView(image: UIImage(named: "editIcon.png"))
        imageView.contentMode = .scaleAspectFit
        let centerButton =  UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.frame = centerButton.bounds
        centerButton.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        let gestrueTapCircleButton = UITapGestureRecognizer(target: self, action: #selector(DetailSongViewController.editButtonAction))
        imageView.addGestureRecognizer(gestrueTapCircleButton)
        self.navigationItem.titleView = centerButton
    }
    
    @objc func tapOnChordLabel() {
        
    }
    
    @objc func editButtonAction() {
        
    }
}

extension DetailSongViewController: ChordTextViewDelegat {
    func clickOnChord(chord: Chord) {
            chordView.isHidden = false
            chordLabel.text = chord.getCurrentChordString().first
            chordChordView = chord
    }
}
