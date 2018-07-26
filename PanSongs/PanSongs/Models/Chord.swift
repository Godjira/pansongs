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
    var p: [Character]
    var f: [[Character]]
}
// -

class Chord {
    
    var chordStruct: ChordStruct

    // For "TextDraw"
    let fingers: [Character] = ["➀", "➁", "➂", "➃"]

    let pArray: [Character]?
    
    let base: String = """
                    ●|\(pArray[0])|\(pArray[1])|\(pArray[2])|\(pArray[3])|\(pArray[4])|
                    ●|➀|-|-|-|-|
                    ●|-|➁|-|-|-|
                    ●|-|-|➂|-|-|
                    ●|-|-|➂|-|-|
                    ●|➀|-|-|-|-|
                      4 5 6 7 8
                    """
    
    
    init(chordStruct: ChordStruct) {
        self.chordStruct = chordStruct
        pArray = ["-", "-", "-", "-", "-"]
    }
    
    
    
}
