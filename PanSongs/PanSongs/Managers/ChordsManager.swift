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

    func getChordFromText(chord: String) -> Chord {

        let asset = NSDataAsset(name: "chords", bundle: Bundle.main)
        let json = try? JSONSerialization.jsonObject(with: asset!.data,
                                                        options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
        let EADGBE = json!["EADGBE"] as! [String: AnyObject]
        let chordDic = EADGBE[chord] as! [[String: String]]
        
        var positions: [Position] = []
        for dic in chordDic{
            let position = Position(p: dic["p"]!, f: dic["f"]!)
            positions.append(position)
        }

        return Chord(name: chord, positions: positions)
    }



}
