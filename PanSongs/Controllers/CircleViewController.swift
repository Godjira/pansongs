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
    
    var chordsManager = ChordsManager.shared()
    var songVC: SongViewController?
    
    var chords: [Chord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            songVC?.chords = chords
            songVC?.customKeyboard.tableView.reloadData()
            print(chords.first?.chordStruct.name)
        }
    }
    
    @IBAction func clickOnChordAction(_ sender: UIButton) {
        if sender.layer.cornerRadius == 0 {
            sender.layer.cornerRadius = 15
            sender.backgroundColor = UIColor.red
            // Get chord
            guard let chord = chordsManager.getChordFromText(chord: sender.titleLabel!.text!) else { return }
            // Get first chord position for view
            let strings = chord.getChordViewString(position: chord.chordStruct.positions.first!)
            chords.append(chord)
            chordsCollection.reloadData()
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
}

extension CircleViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordCollectionViewCell", for: indexPath)
            as? ChordCollectionViewCell else { return UICollectionViewCell() }
        cell.setChord(chord: chords[indexPath.row])
        
        return cell
    }
    
}
