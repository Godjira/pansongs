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

  static let shared = CoreDataManager()
  
  var context: NSManagedObjectContext?
  
  func fetch<T: NSManagedObject>(entity:T.Type, sortBy key: String? = nil, ascending: Bool = true, predicate: NSPredicate? = nil) -> [T]? {
    let entityName = String(describing: entity).components(separatedBy: ".").last!
    let request    = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    
    request.returnsObjectsAsFaults = false
    request.predicate = predicate
    
    if let key = key {
      let sorter = NSSortDescriptor(key:key, ascending:ascending)
      request.sortDescriptors = [sorter]
    }
    do {
      let lists = try context?.fetch(request)
      return lists as? [T]
    } catch {
      print("Error with request: \(error)")
      return nil
    }
  }
  
  func deleteEntity<T>(_ entity: T) {
    context?.delete(entity as! NSManagedObject)
    saveContext()
  }

  func saveContext() {
    do {
      try context?.save()
    } catch { print("Failed saving") }
  }
  
  func delete(song: Song) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
    do {
      let objects = try context?.fetch(fetchRequest) as! [Song]
      for object in objects {
        if object.localId == song.localId {
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
