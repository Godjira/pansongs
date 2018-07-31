//
//  CollectionViewCell.swift
//  PanSongs
//
//  Created by Godjira on 7/26/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class ChordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameChord: UILabel!
    @IBOutlet weak var chordString: UILabel!
    
    var chord: Chord?
    
    var currentChordPosition: [String]?
    
    var timer: Timer?
    var timerCounter = 0
    
    func setChord(chord: Chord) {
        self.chord = chord
        nameChord.text = chord.chordStruct.name
        currentChordPosition = self.chord?.getCurrentChordString()
        chordString.text = currentChordPosition?.first
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateFingers), userInfo: nil, repeats: true)
    }
    
    @objc func updateFingers() {
        if timerCounter > ((currentChordPosition?.count)! - 1) {
            timerCounter = 0
        }
        chordString.text = currentChordPosition?[timerCounter]
        timerCounter = timerCounter + 1
    }
    
    
    
    @IBAction func positionNextAction(_ sender: Any) {
        chord?.nextChordPosition()
        currentChordPosition = self.chord?.getCurrentChordString()
        chordString.text = currentChordPosition?.first
    }
    @IBAction func positionPrevAction(_ sender: Any) {
        chord?.prevChordPosition()
        currentChordPosition = self.chord?.getCurrentChordString()
        chordString.text = currentChordPosition?.first
    }
}
