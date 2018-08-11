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
    
    func getChordFromText(chord: String) -> Chord {
        let EADGBE = json["EADGBE"] as! [String: AnyObject]
        let chordDic = EADGBE[chord] as! [[String: String]]
        
        var positions: [Position] = []
        for dic in chordDic {
            let pString = dic["p"]!
            let pCharacters = pString.components(separatedBy: ",")
            
            let fString = dic["f"]!
            let fStringComponents: [String] = fString.components(separatedBy: ";")
            let fArray: [[Character]] = fStringComponents.map { Array($0) }
            
            positions.append(Position(p: pCharacters, f: fArray))
        }
        
        return Chord(chordStruct: ChordStruct(name: chord, positions: positions))
    }
    
    
    
}
