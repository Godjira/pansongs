//
//  Song+CoreDataProperties.swift
//  PanSongs
//
//  Created by Godjira on 8/27/18.
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
    @NSManaged public var date: Date?
    @NSManaged public var descriptionSong: String?
    @NSManaged public var name: String?
    @NSManaged public var textTextView: NSAttributedString?
    @NSManaged public var widthTextView: Float
    @NSManaged public var chords: [String]?
    @NSManaged public var localId: String?

}
