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
    var addSongVC: AddSongViewController?
    
    var chords: [Chord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(CircleViewController.nextAction))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func nextAction() {
        if addSongVC == nil {
            addSongVC = storyboard?.instantiateViewController(withIdentifier: "AddSongViewController") as? AddSongViewController
        }
        self.addSongVC?.chords = self.chords
        navigationController?.pushViewController(self.addSongVC!, animated: true)
    }
    
    @IBAction func clickOnChordAction(_ sender: UIButton) {
        if sender.layer.cornerRadius == 0 {
            sender.layer.cornerRadius = 15
            sender.backgroundColor = UIColor.red
            // Get and add chord to array
            let chord = chordsManager.getChordFromText(chord: sender.titleLabel!.text!)
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
