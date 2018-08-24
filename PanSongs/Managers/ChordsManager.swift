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
    static func shared() -> ChordsManager {
        if uniqueInstance == nil {
            uniqueInstance = ChordsManager()
        }
        return uniqueInstance!
    }
    
    var json = [String: AnyObject]()
    
    func loadChordJSON() {
        let asset = NSDataAsset(name: "chords", bundle: Bundle.main)
        guard let json = try? JSONSerialization.jsonObject(with: asset!.data,
                                                           options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            else { print("JSON no load")
                return }
        self.json = json
    }
    
    func getChordFromText(nameChord: String) -> Chord? {
        guard let EADGBE = json["EADGBE"] as? [String: AnyObject] else { return nil }
        guard let chordDic = EADGBE[nameChord] as? [[String: String]]  else { return nil }
        
        var positions: [Position] = []
        for dic in chordDic {
            let pString = dic["p"]!
            let pCharacters = pString.components(separatedBy: ",")
            
            let fString = dic["f"]!
            let fStringComponents: [String] = fString.components(separatedBy: ";")
            let fArray: [[Character]] = fStringComponents.map { Array($0) }
            
            positions.append(Position(p: pCharacters, f: fArray))
        }
        return Chord(chordStruct: ChordStruct(name: nameChord, positions: positions))
    }
    
    func getAdditionalChord(chord: Chord) -> [Chord]? {
        guard let EADGBE = json["EADGBE"] as? [String: AnyObject] else { return nil }
        var chords = [Chord]()
        EADGBE.map { if $0.key.range(of: chord.chordStruct.name) != nil {
            if $0.key.range(of: chord.chordStruct.name + "m") == nil &&
                $0.key.range(of: chord.chordStruct.name + "b") == nil &&
                $0.key.range(of: chord.chordStruct.name + "#") == nil {
                chords.append(getChordFromText(nameChord: $0.key)!)
            }
            }
        }
        print(chords.count)
        for chord in chords {
            if checkIsFromCircle(chord: chord) {
                chords.remove(at: chords.index(where: { chord.chordStruct.name == $0.chordStruct.name })!)
            }
        }
        return chords
    }
    
    let chordsFromCircle = ["C", "G", "D", "A", "E", "B", "Cb", "Gb", "F#", "Db", "C#", "Ab", "Eb", "Bb", "F", "Am", "Em", "Bm", "F#m", "C#m", "G#m", "Ebm", "Bbm", "Fm", "Cm", "Gm", "Dm"]
    
    func checkIsFromCircle(chord: Chord) -> Bool{
        for nameChord in chordsFromCircle {
            if nameChord == chord.chordStruct.name {
                return true
            }
        }
        return false
    }
    
}
