//
//  SongListViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/8/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func addBarButtonAction(_ sender: Any) {
        let circleVC = storyboard?.instantiateViewController(withIdentifier: "CircleViewController") as! CircleViewController
        navigationController?.pushViewController(circleVC, animated: true)
    }
    
}
