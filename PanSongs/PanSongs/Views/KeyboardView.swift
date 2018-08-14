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
  func addSpace(howSpace: Int)
  func moveCursorToLeft()
  func moveCursorToRight()
  func removeCharacterChordsTextView()
  func newLineChordTextView()
  func insertChord(chord: Chord)
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
  @IBAction func moveCursorToLeftAction(_ sender: UIButton) {
    delegate?.moveCursorToLeft()
  }
  @IBAction func moveCursorToRight(_ sender: UIButton) {
    delegate?.moveCursorToRight()
  }
  @IBAction func smallSpaceAction(_ sender: Any) {
    delegate?.addSpace(howSpace: 1)
  }
  @IBAction func middleSpaceAction(_ sender: Any) {
    delegate?.addSpace(howSpace: 2)
  }
  @IBAction func largeSpaceAction(_ sender: Any) {
    delegate?.addSpace(howSpace: 3)
  }
  @IBAction func nextLineAction(_ sender: Any) {
    delegate?.newLineChordTextView()
  }
  @IBAction func removeAction(_ sender: Any) {
    delegate?.removeCharacterChordsTextView()
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
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.insertChord(chord: cell.chord!)
  }
}
