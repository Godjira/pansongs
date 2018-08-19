//
//  SongListViewController.swift
//  PanSongs
//
//  Created by Godjira on 8/8/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import UIKit
import CoreData

class SongListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var songs = [Song]()
    
    override func viewWillAppear(_ animated: Bool) {
        songs = CoreDataManager.shared.getAllSongs()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = .zero
        CoreDataManager.shared.deleteAllSong()
        // Do any additional setup after loading the view.
    }
    @IBAction func addBarButtonAction(_ sender: Any) {
        let songVC = storyboard?.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        navigationController?.pushViewController(songVC, animated: true)
    }
}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let stringAuthor = songs[indexPath.row].author  else { return cell }
        guard let  stringName = songs[indexPath.row].name  else { return cell }
        cell.textLabel?.text = "\(stringAuthor) - \(stringName)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailSongVC = storyboard?.instantiateViewController(withIdentifier: "DetailSongViewController") as! DetailSongViewController
        detailSongVC.song = songs[indexPath.row]
        navigationController?.pushViewController(detailSongVC, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            CoreDataManager.shared.deleteSong(with: songs[indexPath.row].date!)
            songs.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
