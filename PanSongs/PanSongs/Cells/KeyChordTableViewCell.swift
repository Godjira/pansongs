//
//  KeyChordTableViewCell.swift
//  PanSongs
//
//  Created by Godjira on 7/31/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import  UIKit

class KeyChordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameChordLabel: UILabel!
    
    var chord: Chord?
    
    func setChord(chord: Chord) {
        self.chord = chord
        nameChordLabel.text = chord.chordStruct.name
    }
    
    
    @IBAction func infoButton(_ sender: UIButton) {
        print("Chord info")
    }
    

    
}
