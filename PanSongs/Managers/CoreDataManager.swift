//
//  CoreDataManager.swift
//  PanSongs
//
//  Created by Godjira on 8/12/18.
//  Copyright © 2018 pangolier. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    private static var uniqueInstance: CoreDataManager?
    
    private init() {}
    static func shared() -> CoreDataManager {
        if uniqueInstance == nil {
            uniqueInstance = CoreDataManager()
        }
        return uniqueInstance!
    }
    
    var context: NSManagedObjectContext?
    
    func newSong() -> Song {
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: context!)
        let song = Song(entity: entity!, insertInto: context)
        return song
    }
    
    func saveContext() {
        do {
            try context?.save()
        } catch { print("Failed saving") }
    }
    
    func getAllSongs() -> [Song] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        do {
            let result = try context?.fetch(fetchRequest) as! [Song]
            return result
        } catch {
            print(error)
        }
        return [Song]()
    }
    
    func deleteSong(with date: Date) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        do {
            let objects = try context?.fetch(fetchRequest) as! [Song]
            for object in objects {
                if object.date == date {
                context?.delete(object)
                }
            }
            saveContext()
        } catch { print("Failed deleting") }
    }
    // For clean CoreData
    func deleteAllSong() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        do {
            let objects = try context?.fetch(fetchRequest)
            for object in objects! {
                context?.delete(object as! NSManagedObject)
            }
            saveContext()
        } catch { print("Failed deleting") }
    }
}
