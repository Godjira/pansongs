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
    
    var chords: [Chord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }


    @IBAction func clickOnChordAction(_ sender: UIButton) {
        let chord = chordsManager.getChordFromText(chord: sender.titleLabel!.text!)
        chords.append(chord)
    }


    @IBAction func next(_ sender: Any) {
        guard let addSongVC = storyboard?.instantiateViewController(withIdentifier: "AddSongViewController")
            as? AddSongViewController else { return }
        addSongVC.chords = self.chords
        self.present(addSongVC, animated: true)
    }
    

}
