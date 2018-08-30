//
//  ChordManager.swift
//  PanSongs
//
//  Created by Homac on 7/13/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class ChordsManager {
  
  private static var uniqueInstance: ChordsManager?
  private init() {}
  static let shared = ChordsManager()
  
  var json = [String: AnyObject]()
  
  func loadChordJSON() {
    let asset = NSDataAsset(name: "chords", bundle: Bundle.main)
    guard let json = try? JSONSerialization.jsonObject(with: asset!.data,
                                                       options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
      else { print("JSON no load")
        return }
    self.json = json
  }
  
  func getChordFrom(nameChord: String) -> Chord? {
    guard let EADGBE = json["EADGBE"] as? [String: AnyObject] else { return nil }
    guard let chords = EADGBE[nameChord] as? [[String: String]]  else { return nil }
    
    var positions: [Position] = []
    
    for chord in chords {
      let frets = chord["p"]!.components(separatedBy: ",")
      let fingers = chord["f"]!
        .components(separatedBy: ";")
        .map { Array($0) }
      
      positions.append(Position(frets: frets, fingers: fingers))
    }
    return Chord(chordStruct: ChordStruct(name: nameChord, positions: positions))
  }
  
  let chordsFromCircle = ["C", "G", "D", "A", "E", "B", "Cb", "Gb", "F#", "Db", "C#", "Ab", "Eb", "Bb", "F", "Am", "Em", "Bm", "F#m", "C#m", "G#m", "Ebm", "Bbm", "Fm", "Cm", "Gm", "Dm"]
  
  func getAdditionalChord(from chord: Chord) -> [Chord]? {
    guard let EADGBE = json["EADGBE"] as? [String: AnyObject] else { return nil }
    var chords = [Chord]()
    EADGBE.forEach {
      if $0.key.range(of: chord.chordStruct.name) != nil {
        if $0.key.range(of: chord.chordStruct.name + "m") == nil &&
          $0.key.range(of: chord.chordStruct.name + "b") == nil &&
          $0.key.range(of: chord.chordStruct.name + "#") == nil {
          chords.append(getChordFrom(nameChord: $0.key)!)
        }
      }
    }
    for chord in chords where chordsFromCircle.contains(chord.chordStruct.name) {
        chords.remove(at: chords.index(where: { chord.chordStruct.name == $0.chordStruct.name })!)
    }
    return chords
  }
  
  func getChordsFrom(song: Song) -> [Chord] {
    var chords = [Chord]()
    if song.chords?.count != nil && song.chords?.count != 0 {
      for chord in song.chords! {
        chords.append(ChordsManager.shared.getChordFrom(nameChord: chord)!)
      }
    }
    return chords
  }
}
