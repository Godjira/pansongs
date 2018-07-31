//
//  KeyChordBoardViewController.swift
//  PanSongs
//
//  Created by Godjira on 7/31/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import UIKit

class KeyChordBoardViewController: UIInputViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chords: [Chord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
