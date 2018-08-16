//
//  ChordView.swift
//  PanSongs
//
//  Created by Godjira on 8/15/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class ChordView: UIView {
    
    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var nameChordLabel: UILabel!
    var chord: Chord?
    
    func setChord(chord: Chord) {
        self.chord = chord
        chordLabel.text = chord.getCurrentChordString().first
        nameChordLabel.text = chord.chordStruct.name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    @IBAction func nextPosAction(_ sender: Any) {
        chord?.nextChordPosition()
        chordLabel.text = chord?.getCurrentChordString().first
    }
    @IBAction func prevPosAction(_ sender: Any) {
        chord?.prevChordPosition()
        chordLabel.text = chord?.getCurrentChordString().first
    }
    
}
