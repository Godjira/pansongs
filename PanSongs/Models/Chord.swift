//
//  Chord.swift
//  PanSongs
//
//  Created by Homac on 7/13/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation

// - Chord Structure
struct ChordStruct {
  var name: String
  var positions: [Position]
}
struct Position {
  var p: [String]
  var f: [[Character]]
}
// -

class Chord {
  
  var chordStruct: ChordStruct
  
  // For "TextDraw"
  let fingers: [Character] = ["1", "2", "3", "4"]
  
  let sArray = ["-", "-", "-", "-", "-", "-"]
  let firstColumn = ["●", "●", "●", "●", "●", "●",]
  
  let baseArray: [[String]]
  let fretArray = ["0", "1", "2", "3", "4", "5"]
  let symbolsFret = ["⓪", "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪", "⑫", "⑬", "⑭", "⑮", "⑯", "⑰", "⑱", "⑲", "⑳"]
  
  
  init(chordStruct: ChordStruct) {
    self.chordStruct = chordStruct
    
    baseArray = [sArray, sArray, sArray, sArray, sArray, sArray]
    
    maxChordPosition = chordStruct.positions.count
    maxFingerVariation = chordStruct.positions.first?.f.count ?? 0
  }
  
  var maxChordPosition = 0
  var maxFingerVariation = 0
  
  var currentChordPosition = 0
  var currentFingerVariation = 0
  
  func nextChordPosition() {
    currentChordPosition = currentChordPosition + 1
    if checkOutOfRange(currentValue: currentChordPosition, maxValue: maxChordPosition - 1) {
      currentChordPosition = 0 } }
  func prevChordPosition() {
    currentChordPosition = currentChordPosition - 1
    if checkOutOfRange(currentValue: currentChordPosition, maxValue: maxChordPosition - 1) {
      currentChordPosition = maxChordPosition - 1 } }
  func nextFingerVariation() {
    currentFingerVariation = currentFingerVariation + 1
    if checkOutOfRange(currentValue: currentFingerVariation, maxValue: maxFingerVariation - 1) {
      currentFingerVariation = 0 } }
  func prevFingerVariation() {
    currentFingerVariation = currentFingerVariation - 1
    if checkOutOfRange(currentValue: currentFingerVariation, maxValue: maxFingerVariation - 1) {
      currentFingerVariation = maxFingerVariation - 1 } }
  
  func checkOutOfRange(currentValue: Int, maxValue: Int) -> Bool {
    if currentValue > maxValue  || currentValue < 0 { return true }
    return false }
  
  func getCurrentChordString() -> [String] {
    let chordStrings = getChordViewString(position: chordStruct.positions[currentChordPosition])
    return chordStrings
  }
  
  func getChordViewString(position: Position) -> [String] {
    var baseArray = self.baseArray
    var fretArray = self.fretArray
    var firstColumn = self.firstColumn
    var rStrings = [String]()
    
    // Get min fret
    var intPos = [Int]()
    for fret in position.p {
      if let additionalFret = Int(String(fret)) {
        if additionalFret > 0 {
          intPos.append(additionalFret)
        }
      }
    }
    // Set fret
    let minFret = intPos.min() ?? 0
    fretArray = [symbolsFret[minFret],
                 symbolsFret[minFret + 1],
                 symbolsFret[minFret + 2],
                 symbolsFret[minFret + 3],
                 symbolsFret[minFret + 4],
                 symbolsFret[minFret + 5]]
    
    var fingerVariationIncrement = 0
    while fingerVariationIncrement < position.f.count {
      baseArray = self.baseArray
      
      var i = 0
      var fingerIncrement = 0
      while i < baseArray.count {
        
        if let fret = Int(position.p[i]) {
          if fret > 0 && position.f.first!.count > 0 {
            let fingerString = String(position.f[fingerVariationIncrement][fingerIncrement])
            var indexFinger = Int(fingerString) ?? 0
            if indexFinger > 0 { indexFinger = indexFinger - 1 }
            if let symbol: Character = fingers[indexFinger] {
              baseArray[i][fret - minFret] = String(symbol)
            } else { firstColumn[i] = "o" }
            fingerIncrement = fingerIncrement + 1
          } else { firstColumn[i] = "o" }
        } else { firstColumn[i] = "x"}
        i = i + 1
      }
      rStrings.append(getModifyBaseString(baseArray: baseArray, firstColumn: firstColumn, fretArray: fretArray))
      fingerVariationIncrement = fingerVariationIncrement + 1
    }
    return rStrings
  }
  
  func getModifyBaseString(baseArray: [[String]],firstColumn: [String], fretArray: [String]) -> String {
    let base = """
    \(firstColumn[0])|\(baseArray[0][0])|\(baseArray[0][1])|\(baseArray[0][2])|\(baseArray[0][3])|\(baseArray[0][4])|\(baseArray[0][5])|
    \(firstColumn[1])|\(baseArray[1][0])|\(baseArray[1][1])|\(baseArray[1][2])|\(baseArray[1][3])|\(baseArray[1][4])|\(baseArray[1][5])|
    \(firstColumn[2])|\(baseArray[2][0])|\(baseArray[2][1])|\(baseArray[2][2])|\(baseArray[2][3])|\(baseArray[2][4])|\(baseArray[2][5])|
    \(firstColumn[3])|\(baseArray[3][0])|\(baseArray[3][1])|\(baseArray[3][2])|\(baseArray[3][3])|\(baseArray[3][4])|\(baseArray[3][5])|
    \(firstColumn[4])|\(baseArray[4][0])|\(baseArray[4][1])|\(baseArray[4][2])|\(baseArray[4][3])|\(baseArray[4][4])|\(baseArray[4][5])|
    \(firstColumn[5])|\(baseArray[5][0])|\(baseArray[5][1])|\(baseArray[5][2])|\(baseArray[5][3])|\(baseArray[5][4])|\(baseArray[5][5])|
    \(fretArray[0])\(fretArray[1])\(fretArray[2]) \(fretArray[3])\(fretArray[4])\(fretArray[5])
    """
    return base
  }
  
}

