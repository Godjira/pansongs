//
//  CircleViewController.swift
//  PanSongs
//
//  Created by Homac on 7/13/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class CircleViewController: UIViewController {
  
  @IBOutlet weak var chordsCollection: UICollectionView!
  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var circleImageView: UIImageView!
  
  var song: Song?
  
  @IBOutlet weak var additionalChordsCollectionView: UICollectionView!
  
  var chords: [Chord] = []
  var additionalChords: [Chord] = []
  var timerUpdateFingerInCell: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Choose chords"
    let okButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(CircleViewController.okButtonAction))
    navigationItem.leftBarButtonItem = okButton
    circleImageView.image = circleImageView.image?.withRenderingMode(.alwaysTemplate)
    circleImageView.tintColor = .secondary
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    for subView in circleView.subviews {
      if ((subView as? UIButton) != nil) {
        subView.tintColor = .secondary
      }
    }
    timerUpdateFingerInCell = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateFingersInCell), userInfo: nil, repeats: true)
  }
  
  @objc func updateFingersInCell() {
    for cell in chordsCollection.visibleCells {
      if let cell: ChordCollectionViewCell = cell as? ChordCollectionViewCell {
        cell.updateFingers()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCircleViewOverTheTop()
    setAdCollectToOverTheTop()
    animateCircleViewToOldPosition()
    setupChords()
  }
  
  private func setupChords() {
    chords = ChordsManager.shared.getChordsFrom(song: song!)
    for subView in circleView.subviews {
      if let chordButton: UIButton = subView as? UIButton {
        for chord in chords {
          if chordButton.currentTitle == chord.chordStruct.name {
            chordButton.layer.cornerRadius = 15
            chordButton.backgroundColor = .secondary
            chordButton.setTitleColor(.white, for: .normal)
            chordsCollection.reloadData()
          }
        }
      }
    }
  }
  
  @objc func okButtonAction() {
    self.navigationController?.popViewController(animated: true)
  }
  override func viewWillDisappear(_ animated : Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParentViewController {
      song?.chords = self.chords.map { $0.chordStruct.name }
    }
  }
  
  @IBAction func clickOnChordAction(_ sender: UIButton) {
    if sender.layer.cornerRadius == 0 {
      sender.layer.cornerRadius = 15
      sender.backgroundColor = .secondary
      sender.setTitleColor(.white, for: .normal)
      // Get chord
      guard let chord = ChordsManager.shared.getChordFromText(nameChord: sender.titleLabel!.text!) else { return }
      // Get first chord position for view
      chords.append(chord)
      chordsCollection.reloadData()
      chordsCollection.scrollToLastIndexPath(position: .right, animated: true)
    } else {
      sender.layer.cornerRadius = 0
      sender.backgroundColor = UIColor.clear
      sender.setTitleColor(.secondary, for: .normal)
      // Delete chord from array
      if let index = chords.index(where: { $0.chordStruct.name == sender.titleLabel!.text! }) {
        // removing item
        chords.remove(at: index)
      }
      chordsCollection.reloadData()
    }
  }
  
  deinit {
    timerUpdateFingerInCell?.invalidate()
    timerUpdateFingerInCell = nil
  }
  
  // MARK: - Circle and AdditionalChordCollectionView Animation
  // Circle animations
  private var oldCircleViewCenter: CGPoint?
  private var overTheTopCircleCenter: CGPoint?
  
  private func setCircleViewOverTheTop() {
    let widthScreen = UIScreen.main.bounds.width
    circleView.center.y =  circleView.frame.height / 2
    circleView.center.x = widthScreen / 2
    oldCircleViewCenter = circleView.center
    // Set over top position
    circleView.center.y = -circleView.frame.height
    overTheTopCircleCenter = circleView.center
    self.circleView.alpha = 0
  }
  
  private func animateCircleViewToOldPosition() {
    guard oldCircleViewCenter != nil else { return }
    UIView.animate(withDuration: 0.5) {
      self.circleView.alpha = 1
      self.circleView.center = self.oldCircleViewCenter!
    }
  }
  private func animateCircleViewToOverTheTopPosition() {
    guard overTheTopCircleCenter != nil else { return }
    self.circleView.alpha = 0.3
    UIView.animate(withDuration: 0.5) {
      self.circleView.center = self.overTheTopCircleCenter!
    }
  }
  // AdditionalCollection animation
  private var oldAdditColectionViewFrame: CGRect?
  private var overTheTopAdditColectionFrame: CGRect?
  
  private func setAdCollectToOverTheTop() {
    oldAdditColectionViewFrame = additionalChordsCollectionView.frame
    guard let oldAdditColectionViewFrame = oldAdditColectionViewFrame else { return }
    additionalChordsCollectionView.frame = CGRect(x: oldAdditColectionViewFrame.origin.x, y: -oldAdditColectionViewFrame.height, width: oldAdditColectionViewFrame.width, height: oldAdditColectionViewFrame.height)
    overTheTopAdditColectionFrame = additionalChordsCollectionView.frame
    self.additionalChordsCollectionView.alpha = 0
  }
  
  private func animateAdCollectToOldPosition() {
    guard oldAdditColectionViewFrame != nil else { return }
    UIView.animate(withDuration: 0.5) {
      self.additionalChordsCollectionView.alpha = 1
      self.additionalChordsCollectionView.frame = self.oldAdditColectionViewFrame!
    }
  }
  
  private func animateAdCollectToOverTheTopPosition() {
    guard oldAdditColectionViewFrame != nil else { return }
    self.additionalChordsCollectionView.alpha = 0.3
    UIView.animate(withDuration: 0.5) {
      self.additionalChordsCollectionView.frame = self.overTheTopAdditColectionFrame!
    }
  }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == chordsCollection {
      return chords.count
    }
    if collectionView == additionalChordsCollectionView {
      if additionalChords.count == 0 { return 0 }
      // +1 for back cell (to circle)
      return additionalChords.count + 1
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == chordsCollection {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordCollectionViewCell", for: indexPath)
        as? ChordCollectionViewCell else { return UICollectionViewCell() }
      cell.chordDelegat = self
      let isFromCircle = ChordsManager.shared.checkIsFromCircle(chord: chords[indexPath.row])
      cell.setChord(chord: chords[indexPath.row], fromCircle: isFromCircle)
      return cell
    }
    if collectionView == additionalChordsCollectionView {
      // Create cell for back to circle
      if indexPath.row == 0 {
        guard let backCell = collectionView.dequeueReusableCell(withReuseIdentifier: "backCell", for: indexPath)
          as? AdditionalChordCollectionViewCell else { return UICollectionViewCell() }
        backCell.nameChordLabel.text = "⇪"
        backCell.backgroundColor = .tertiary
        backCell.nameChordLabel.textColor = .background2
        return backCell
      }
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalChordCollectionViewCell", for: indexPath)
        as? AdditionalChordCollectionViewCell else { return UICollectionViewCell() }
      let additionalChord = additionalChords[indexPath.row - 1]
      cell.nameChordLabel.text = additionalChord.chordStruct.name
      cell.additionalChord = additionalChord
      cell.backgroundColor = .secondary
      cell.nameChordLabel.textColor = .primary
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == chordsCollection {
      
    }
    if collectionView == additionalChordsCollectionView {
      // If did select BackCell
      if indexPath.row == 0 {
        animateAdCollectToOverTheTopPosition()
        animateCircleViewToOldPosition()
        return
      }
      guard let cell = collectionView.cellForItem(at: indexPath) as? AdditionalChordCollectionViewCell else { return }
      chords.append(cell.additionalChord!)
      chordsCollection.reloadData()
      chordsCollection.scrollToLastIndexPath(position: .right, animated: true)
    }
  }
}

extension CircleViewController: ChordCollectionViewCellDelegat {
  
  func deleteChord(chord: Chord) {
    chords.remove(at: chords.index(where: { $0.chordStruct.name == chord.chordStruct.name })!)
    self.chordsCollection.reloadData()
  }
  
  func addAdditionalChord(fromChord: Chord) {
    self.additionalChords = ChordsManager.shared.getAdditionalChord(chord: fromChord)!
    additionalChordsCollectionView.reloadData()
    animateCircleViewToOverTheTopPosition()
    animateAdCollectToOldPosition()
  }
}
