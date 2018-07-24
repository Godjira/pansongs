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

    func getChordFromText(chord: String) -> Void {

        let asset = NSDataAsset(name: "chords", bundle: Bundle.main)
        let json = try? JSONSerialization.jsonObject(with: asset!.data,
                                                        options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
        let EADGBE = json!["EADGBE"] as! [String: AnyObject]
        let chord = EADGBE[chord] as! [[String: String]]
        print(chord.first!["p"])



    }



//    func getCmajor() -> Chord {
//        let asset = NSDataAsset(name: "major", bundle: Bundle.main)
//        guard let json = try? JSONSerialization.jsonObject(with: asset!.data,
//                                                           options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
//            else { return Chord(key: "0", positions: [], suffix: "0") }
//        var positions: [Position] = []
//        let jsonPos = json?["positions"] as? [[String: AnyObject]]
//        for pos in jsonPos! {
//            let newPos = Position(fingers: pos["fingers"] as? String ?? "",
//                                  frets: pos["frets"] as? String ?? "",
//                                  barres: pos["barres"] as? Int ?? 0,
//                                  capo: pos["capo"] as? Bool ?? false)
//            positions.append(newPos)
//        }
//
//        let chord = Chord(key: json?["key"] as? String ?? "", positions: positions, suffix: json?["suffix"] as? String ?? "")
//        return chord
//    }

}
