//
//  KeyboardViewController.swift
//  PanSongs
//
//  Created by betraying on 7/31/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

protocol SendDelegate: class {
  func send(text: String)
}

class KeyboardView: UIView {
  
  @IBOutlet weak var tableView: UITableView!

  weak var delegate: SendDelegate?
  
  var chords: [Chord] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  
  func reloadData() {
    tableView.reloadData()
  }
  
}

extension KeyboardView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chords.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "KeyChordTableViewCell") as! KeyChordTableViewCell
    let chord: Chord = chords[indexPath.row]
    cell.setChord(chord: chord)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! KeyChordTableViewCell
    delegate?.send(text: (cell.chord?.chordStruct.name)!)
  }
  
}
