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
    songs = CoreDataManager.shared.fetch(entity: Song.self) ?? []
    tableView.reloadData()
    title = "Song list"
    let footerView = UIView()
    footerView.backgroundColor = .background
    tableView.tableFooterView = footerView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.frame = .zero
    // Do any additional setup after loading the view.
  }
  @IBAction func addBarButtonAction(_ sender: Any) {
    let songVC = storyboard?.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
    let song = Song(context: CoreDataManager.shared.context!)
    song.localId = NSUUID().uuidString
    songVC.song = song
    navigationController?.pushViewController(songVC, animated: true)
  }
}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return songs.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    guard let stringAuthor = songs[indexPath.row].author  else { return cell }
    guard let  stringName = songs[indexPath.row].name  else { return cell }
    cell.textLabel?.text = "\(stringAuthor) - \(stringName)"
    cell.textLabel?.textColor = .secondary
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
      CoreDataManager.shared.deleteEntity(songs[indexPath.row])
      songs.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
}
