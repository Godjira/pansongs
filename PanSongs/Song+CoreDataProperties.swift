//
//  Song+CoreDataProperties.swift
//  PanSongs
//
//  Created by Godjira on 8/15/18.
//  Copyright © 2018 pangolier. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var author: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var descriptionSong: String?
    @NSManaged public var name: String?
    @NSManaged public var textTextView: NSAttributedString?

}
