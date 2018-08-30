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
  var frets: [String]
  var fingers: [[Character]]
}
// -

class Chord {
  
  var chordStruct: ChordStruct
  
  // For "TextDraw"
  let fingers: [String] = ["1", "2", "3", "4"]
  let firstColumn = ["●", "●", "●", "●", "●", "●",]
  
  let baseArray: [[String]]
  let sArray = ["-", "-", "-", "-", "-", "-"]
  
  let symbolsFret = ["⓪", "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪", "⑫", "⑬", "⑭", "⑮", "⑯", "⑰", "⑱", "⑲", "⑳"]
  
  init(chordStruct: ChordStruct) {
    self.chordStruct = chordStruct
    
    baseArray = [sArray, sArray, sArray, sArray, sArray, sArray]
    
    maxChordPosition = chordStruct.positions.count
    maxFingerVariation = chordStruct.positions.first?.fingers.count ?? 0
  }
  
  var currentVatiations: [String] {
    return composeFingersVariations(for: chordStruct.positions[currentChordPosition])
  }
  
  var maxChordPosition = 0
  var maxFingerVariation = 0
  
  var currentChordPosition = 0
  var currentFingerVariation = 0
  
  func nextChordPosition() {
    currentChordPosition = currentChordPosition + 1
    if checkOutOfRange(currentValue: currentChordPosition, maxValue: maxChordPosition - 1) {
      currentChordPosition = 0
    }
  }
  
  func prevChordPosition() {
    currentChordPosition = currentChordPosition - 1
    if checkOutOfRange(currentValue: currentChordPosition, maxValue: maxChordPosition - 1) {
      currentChordPosition = maxChordPosition - 1
    }
  }
  
  func nextFingerVariation() {
    currentFingerVariation = currentFingerVariation + 1
    if checkOutOfRange(currentValue: currentFingerVariation, maxValue: maxFingerVariation - 1) {
      currentFingerVariation = 0
    }
  }
  
  func prevFingerVariation() {
    currentFingerVariation = currentFingerVariation - 1
    if checkOutOfRange(currentValue: currentFingerVariation, maxValue: maxFingerVariation - 1) {
      currentFingerVariation = maxFingerVariation - 1
    }
  }
  
  func checkOutOfRange(currentValue: Int, maxValue: Int) -> Bool {
    if currentValue > maxValue  || currentValue < 0 { return true }
    return false }
  
  func composeFingersVariations(for position: Position) -> [String] {
    var firstColumn = self.firstColumn
    var baseArray = self.baseArray
    var fingersVariations = [String]()
    
    let minFret = getMinFret(for: position)

    for fingerVariation in 0..<position.fingers.count {
      baseArray = self.baseArray
      
      var fingerIncrement = 0
      
      for i in 0..<baseArray.count {
        if let fret = Int(position.frets[i]) {
          if fret > 0 && position.fingers.first!.count > 0 {
            let finger = String(position.fingers[fingerVariation][fingerIncrement])
            var indexFinger = Int(finger) ?? 0
            
            if indexFinger > 0 {
              indexFinger = indexFinger - 1
            }
            baseArray[i][fret - minFret] = fingers[indexFinger]
            fingerIncrement = fingerIncrement + 1
          } else {
            firstColumn[i] = "o"
          }
        } else {
          firstColumn[i] = "x"
        }
      }
      
      let frets = getFrets(minFret: minFret)
      fingersVariations.append(getModifyBaseString(baseArray: baseArray,
                                          firstColumn: firstColumn,
                                          frets: frets))
    }
    return fingersVariations
  }
  
  func getFrets(minFret: Int) -> [String] {
    return [symbolsFret[minFret],
            symbolsFret[minFret + 1],
            symbolsFret[minFret + 2],
            symbolsFret[minFret + 3],
            symbolsFret[minFret + 4],
            symbolsFret[minFret + 5]]
  }
  
  func getMinFret(for position: Position) -> Int {
    var intPos = [Int]()
    for fret in position.frets {
      if let additionalFret = Int(String(fret)) {
        if additionalFret > 0 {
          intPos.append(additionalFret)
        }
      }
    }
    return intPos.min() ?? 0
  }
  
  func getModifyBaseString(baseArray: [[String]],firstColumn: [String], frets: [String]) -> String {
    var modifyBaseString = ""
    
    for i in 0..<6 {
      modifyBaseString.append(firstColumn[i])
      modifyBaseString.append("|")
      
      for j in 0..<6 {
        modifyBaseString.append(baseArray[i][j])
        modifyBaseString.append("|")
      }
      
      modifyBaseString.append("\n")
    }
    modifyBaseString.append(" ")
    for i in 0..<6 {
      modifyBaseString.append(frets[i])
      
      if i == 2 {
        modifyBaseString.append(" ")
      }
    }
    
    return modifyBaseString
  }
  
}

