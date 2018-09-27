//
//  ProfileManager.swift
//  PanSongs
//
//  Created by Godjira on 9/8/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseManager {
  
  private init() {}
  static let shared = FirebaseManager()
  
  let ref = Database.database().reference()
  
  func send(song: Song) {
    let fireId = ref.childByAutoId().key
   
    setToFirebase(song: song, id: fireId)
  }
}

extension FirebaseManager {
  
  private func setToFirebase(song: Song, id: String) {
    let text = stringFrom(attrString: song.textTextView!)
 ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("localId").setValue(song.localId)
    ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("name").setValue(song.name)
    ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("text").setValue(text)
    ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("author").setValue(song.author)
    ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("chords").setValue(song.chords)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    let dateString = formatter.string(from: song.date!)
    ref.child("songs").child((Auth.auth().currentUser?.uid)!).child(id).child("date").setValue(dateString)
  }
  
  private func stringFrom(attrString: NSAttributedString) -> String {
    var rString = ""
    attrString.enumerateAttribute(.link, in: NSMakeRange(0, attrString.length), options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
      
      if value != nil {
        rString.append("[chord:")
        rString.append(attrString.attributedSubstring(from: range).string)
        rString.append("]")
      } else {
        rString.append(attrString.attributedSubstring(from: range).string)
      }
    }
    
    return rString
  }
}
