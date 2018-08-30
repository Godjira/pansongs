//
//  Song+CoreDataClass.swift
//  PanSongs
//
//  Created by Godjira on 8/27/18.
//  Copyright © 2018 pangolier. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject {

  func load(with name: String?, author: String?, descriptionSong: String?, date: Date?) {
    self.name = name
    self.author = author
    self.descriptionSong = descriptionSong
    self.date = date
  }
}
