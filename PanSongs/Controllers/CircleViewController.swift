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
    
    var chordsManager = ChordsManager.shared()
    var songVC: SongViewController?
    
    @IBOutlet weak var additionalChordsCollectionView: UICollectionView!
    
    var chords: [Chord] = []
    var additionalChords: [Chord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose chords"
        let okButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(CircleViewController.okButtonAction))
        navigationItem.leftBarButtonItem = okButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCircleViewOverTheTop()
        setAdCollectToOverTheTop()
        animateCircleViewToOldPosition()
    }
    @objc func okButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            if songVC != nil {
                songVC?.chords = chords
                songVC?.customKeyboard.tableView.reloadData()
            }
        }
    }
    @IBAction func clickOnChordAction(_ sender: UIButton) {
        if sender.layer.cornerRadius == 0 {
            sender.layer.cornerRadius = 15
            sender.backgroundColor = UIColor.lightGray
            // Get chord
            guard let chord = chordsManager.getChordFromText(nameChord: sender.titleLabel!.text!) else { return }
            // Get first chord position for view
            let strings = chord.getChordViewString(position: chord.chordStruct.positions.first!)
            chords.append(chord)
            chordsCollection.reloadData()
            chordsCollection.scrollToLastIndexPath(position: .right, animated: true)
        } else {
            sender.layer.cornerRadius = 0
            sender.backgroundColor = UIColor.clear
            // Delete chord from array
            if let index = chords.index(where: { $0.chordStruct.name == sender.titleLabel!.text! }) {
                // removing item
                chords.remove(at: index)
            }
            chordsCollection.reloadData()
        }
    }
    
    // MARK: - Circle and AdditionalChordCollectionView Animation
    // Circle animations
    private var oldCircleViewFrame: CGRect?
    private var overTheTopCircleFrame: CGRect?
    
    private func setCircleViewOverTheTop() {
        oldCircleViewFrame = circleView.frame
        guard let oldCircleViewFrame = oldCircleViewFrame else { return }
        circleView.frame = CGRect(x: oldCircleViewFrame.origin.x, y: -oldCircleViewFrame.height, width: oldCircleViewFrame.width, height: oldCircleViewFrame.height)
        overTheTopCircleFrame = circleView.frame
        self.circleView.alpha = 0
    }
    
    private func animateCircleViewToOldPosition() {
        guard oldCircleViewFrame != nil else { return }
        UIView.animate(withDuration: 0.5) {
            self.circleView.alpha = 1
            self.circleView.frame = self.oldCircleViewFrame!
        }
    }
    private func animateCircleViewToOverTheTopPosition() {
        guard overTheTopCircleFrame != nil else { return }
        self.circleView.alpha = 0.3
        UIView.animate(withDuration: 0.5) {
            self.circleView.frame = self.overTheTopCircleFrame!
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
        let isFromCircle = chordsManager.checkIsFromCircle(chord: chords[indexPath.row])
        cell.setChord(chord: chords[indexPath.row], fromCircle: isFromCircle)
        return cell
        }
        if collectionView == additionalChordsCollectionView {
            // Create cell for back to circle
            if indexPath.row == 0 {
                guard let backCell = collectionView.dequeueReusableCell(withReuseIdentifier: "backCell", for: indexPath)
                    as? AdditionalChordCollectionViewCell else { return UICollectionViewCell() }
                backCell.nameChordLabel.text = "⇪"
                return backCell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalChordCollectionViewCell", for: indexPath)
                as? AdditionalChordCollectionViewCell else { return UICollectionViewCell() }
            let additionalChord = additionalChords[indexPath.row - 1]
            cell.nameChordLabel.text = additionalChord.chordStruct.name
            cell.additionalChord = additionalChord
            
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
        self.additionalChords = chordsManager.getAdditionalChord(chord: fromChord)!
        additionalChordsCollectionView.reloadData()
        animateCircleViewToOverTheTopPosition()
        animateAdCollectToOldPosition()
    }
}
