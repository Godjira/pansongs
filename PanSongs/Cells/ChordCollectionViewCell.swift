//
//  CollectionViewCell.swift
//  PanSongs
//
//  Created by Godjira on 7/26/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

protocol ChordCollectionViewCellDelegat {
  func deleteChord(chord: Chord)
  func addAdditionalChord(fromChord: Chord)
}

class ChordCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nameChord: UILabel!
  @IBOutlet weak var chordString: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  
  var chord: Chord?
  
  var currentChordPosition: [String]?
  
  var timerCounter = 0
  
  var chordDelegat: ChordCollectionViewCellDelegat?
  
  @IBAction func buttonAddAdditionalChord(_ sender: Any) {
    chordDelegat?.addAdditionalChord(fromChord: chord!)
  }
  @IBAction func deleteChordButtonAction(_ sender: Any) {
    chordDelegat?.deleteChord(chord: chord!)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    nameChord.textColor = .background2
    chordString.textColor = .white
    deleteButton.setTitleColor(.tertiary, for: .normal)
    addButton.setTitleColor(.tertiary, for: .normal)
    contentView.backgroundColor = .background
  }
  
  func setChord(chord: Chord, fromCircle: Bool) {
    if fromCircle {
      deleteButton.isHidden = true
      addButton.isHidden = false
    } else {
      addButton.isHidden = true
      deleteButton.isHidden = false
    }
    self.chord = chord
    nameChord.text = chord.chordStruct.name
    currentChordPosition = self.chord?.getCurrentChordString()
    chordString.text = currentChordPosition?.first
  }
  
   func updateFingers() {
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
