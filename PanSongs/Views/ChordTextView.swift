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
  
  func insertChord(chord: Chord) {
    let text: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    
    text.addAttribute(NSAttributedStringKey.font,
                      value: UIFont.systemFont(ofSize: 12),
                      range: NSRange(location: 0, length: text.length))
    
    let interactableText = NSMutableAttributedString(string: chord.chordStruct.name)
    interactableText.addAttribute(NSAttributedStringKey.font,
                                  value: UIFont.systemFont(ofSize: 12),
                                  range: NSRange(location: 0, length: interactableText.length))
    // Adding the link interaction to the interactable text
    interactableText.addAttribute(NSAttributedStringKey.link,
                                  value: "Chord",
                                  range: NSRange(location: 0, length: interactableText.length))
    // Adding it all together
    let firstAttrSubstring = text.attributedSubstring(from: NSMakeRange(0, self.selectedRange.location))
    let secondAttrSubstring = text.attributedSubstring(from: NSMakeRange(self.selectedRange.location, text.length - firstAttrSubstring.length))
    
    
    let newString: NSMutableAttributedString = firstAttrSubstring.mutableCopy() as! NSMutableAttributedString
    newString.append(interactableText)
    newString.append(NSAttributedString(string: " "))
    newString.append(secondAttrSubstring)
    // Set the text view to contain the attributed text
    let oldRange = self.selectedRange
    attributedText = newString
    self.selectedRange = NSMakeRange(oldRange.location + interactableText.length + 1, oldRange.length)
    // Disable editing, but enable selectable so that the link can be selected
    //                isEditable = true
    //                isSelectable = false
  }
  
  // Key-Chord function
  func send(text: String) {
    let mutableString: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    mutableString.append(NSAttributedString(string: text))
    self.attributedText = mutableString
  }
  
  func addSpace(howSpace: Int) {
    let text: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    var stringSpace = ""
    var i = 0
    while i < howSpace {
      stringSpace.append(" ")
      i = i + 1 }
    text.append(NSAttributedString(string: stringSpace))
    self.attributedText = text
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
    let mutableString: NSMutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
    
    let firstAttrSubstring = mutableString.attributedSubstring(from: NSMakeRange(0, self.selectedRange.location))
    let secondAttrSubstring = mutableString.attributedSubstring(from: NSMakeRange(self.selectedRange.location, mutableString.length - firstAttrSubstring.length))
    
    let newString: NSMutableAttributedString = firstAttrSubstring.mutableCopy() as! NSMutableAttributedString
    newString.append(NSAttributedString(string: "\n"))
    newString.append(secondAttrSubstring)
    
    let oldRange = self.selectedRange
    attributedText = newString
    self.selectedRange = NSMakeRange(oldRange.location + 1, oldRange.length)
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
