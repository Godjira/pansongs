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
    
    var chords: [Chord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose chords"
        let okButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(CircleViewController.okButtonAction))
        navigationItem.leftBarButtonItem = okButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCircleViewOverTheTop()
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
    
    // MARK: - Circle Animation
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
}
extension CircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chords.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordCollectionViewCell", for: indexPath)
            as? ChordCollectionViewCell else { return UICollectionViewCell() }
        cell.setChord(chord: chords[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChordCollectionViewCell else { return }
        chordsManager.getAdditionalChord(chord: cell.chord!)
    }
}
