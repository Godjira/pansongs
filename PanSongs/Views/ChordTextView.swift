//
//  ChordTextView.swift
//  PanSongs
//
//  Created by Godjira on 8/13/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

protocol ChordTextViewDelegate {
   func clickOn(chord: Chord)
   func textViewDidChange()
}

class ChordTextView: UITextView, KeyboardViewDelegate {
  
  let chordManager = ChordsManager.shared()
  var delegatChordTextView: ChordTextViewDelegate?
  
  func insert(chord: Chord) {
    let interactableText = NSMutableAttributedString(string: chord.chordStruct.name)
    interactableText.addAttribute(NSAttributedStringKey.font,
                                  value: UIFont.systemFont(ofSize: 12),
                                  range: NSRange(location: 0, length: interactableText.length))
    // Adding the link interaction to the interactable text
    interactableText.addAttribute(NSAttributedStringKey.link,
                                  value: "Chord",
                                  range: NSRange(location: 0, length: interactableText.length))
    interactableText.append(NSAttributedString(string: " "))
    insertAttributedText(attrString: interactableText)
  }
  
  // Key-Chord function
  func send(text: String) {
    let mutableString: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    mutableString.append(NSAttributedString(string: text))
    self.attributedText = mutableString
  }
  
  func addSpace(howSpace: Int) {
    var stringSpace = ""
    var i = 0
    while i < howSpace {
      stringSpace.append(" ")
      i = i + 1
    }
    insertAttributedText(attrString: NSAttributedString(string: stringSpace))
  }
  
  func moveCursorToLeft() {
    if let selectedRange = self.selectedTextRange {
      // and only if the new position is valid
      if let newPosition = self.position(from: selectedRange.start, offset: -1) {
        // set the new position
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
      }
    }
  }
  
  func moveCursorToRight() {
    if let selectedRange = self.selectedTextRange {
      // and only if the new position is valid
      if let newPosition = self.position(from: selectedRange.start, offset: 1) {
        // set the new position
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
      }
    }
  }
  
  func removeCharacterChordsTextView() {
    if let selectedRange = self.selectedTextRange {
      // and only if the new position is valid
      if let newPosition = self.position(from: selectedRange.start, offset: -1) {
        // remove character
        self.selectedTextRange = self.textRange(from: newPosition, to: selectedRange.end)
        self.replace(self.selectedTextRange!, withText: "")
      }
    }
  }
  
  func newLineChordTextView() {
    insertAttributedText(attrString: NSAttributedString(string: "\n"))
  }
  
  func insertAttributedText(attrString: NSAttributedString) {
    let oldRange = self.selectedRange
    let mutableString: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    
    let firstAttrSubstring = mutableString.attributedSubstring(from: NSMakeRange(0, self.selectedRange.location))
    let secondAttrSubstring = mutableString.attributedSubstring(from: NSMakeRange(self.selectedRange.location, mutableString.length - firstAttrSubstring.length))
    
    let newString: NSMutableAttributedString = firstAttrSubstring.mutableCopy() as! NSMutableAttributedString
    newString.append(attrString)
    newString.append(secondAttrSubstring)
    
    self.attributedText = newString
    self.selectedRange = NSMakeRange(oldRange.location + attrString.length, oldRange.length)
  }
}

extension ChordTextView: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    //Code to the respective action
    print(self.attributedText.attributedSubstring(from: characterRange).string)
    guard let chord = chordManager.getChordFromText(nameChord: self.attributedText.attributedSubstring(from: characterRange).string) else { return false }
    self.delegatChordTextView?.clickOn(chord: chord)
    
    return false
  }
  func textViewDidChange(_ textView: UITextView) {
    delegatChordTextView?.textViewDidChange()
  }
  
}
