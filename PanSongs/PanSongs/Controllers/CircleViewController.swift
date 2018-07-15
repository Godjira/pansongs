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

    override func viewDidLoad() {
        super.viewDidLoad()


//        let chord = ChordsManager.shared().getCmajor()
//        for pos in chord.positions {
//            print(pos.frets)
//            print(pos.fingers)
//            print(pos.barres)
//            print(pos.capo)
//            print(pos.barres)
//            
//        }

    }


    @IBAction func clickOnChordAction(_ sender: UIButton) {

        print(sender.titleLabel!.text)

    }




}
