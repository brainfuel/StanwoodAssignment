//
//  BMData.swift
//  LightControl
//
//  Created by Ben Milford on 01/12/2017.
//  Copyright © 2017 Ben Milford. All rights reserved.
//

import UIKit
import CoreData

var faultsOn = false

/**
Simple Active Record style class for Core Data
Also Removes Core Data set up from AppDelegate
 
 Example use...
 
 let test: Button  = Button.create()
 test.name = "dd"
 
 let buttons: [Button] = Button.findAll()
 
 let singleBut = buttons.first
 
 singleBut?.group =  Group.findAll().first
 singleBut?.group?.addToButtons(singleBut!)
 
 singleBut?.delete()
 
 let descriptor: NSSortDescriptor = NSSortDescriptor(key: "sortValue", ascending: true)
 faderDataArray = Fader.findAllSortedBy([descriptor]) as [Fader]
 
 CoreRecord.shared.save()
*/

class CoreRecord: NSObject {
    
    lazy var viewContext:NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    override init() {
      
    }
    
    static let shared = CoreRecord()
    var containerName = Bundle.main.infoDictionary?["CFBundleName"] as! String //Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    func setUpWithContainer(name: String){
        containerName = name
    }
    
    lazy  var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public func save () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NSManagedObject {
    class func create<T: NSManagedObject>() -> T {
        
        let className =   NSStringFromClass(self).components(separatedBy: ".").last!
        
        return NSEntityDescription.insertNewObject(forEntityName: className, into: CoreRecord.shared.persistentContainer.viewContext) as! T
    }
    
    class func findAll<T: NSManagedObject>() -> [T] {
        
        let className =   NSStringFromClass(self).components(separatedBy: ".").last!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetchRequest.returnsObjectsAsFaults = faultsOn
        
        var  result = [T]()
        do {
            result  = try CoreRecord.shared.persistentContainer.viewContext.fetch(fetchRequest) as! [T]
            
        } catch {
            print(error)
        }
        return result
    }
    
    class func findAllSortedBy<T: NSManagedObject>(_ sortedBy: [NSSortDescriptor]) -> [T] {
        
        let className =   NSStringFromClass(self).components(separatedBy: ".").last!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetchRequest.returnsObjectsAsFaults = faultsOn
        
        fetchRequest.sortDescriptors = sortedBy
        
        var  result = [T]()
        do {
            result  = try CoreRecord.shared.persistentContainer.viewContext.fetch(fetchRequest) as! [T]
            
        } catch {
            print(error)
        }
        return result
    }
    
    class func findAllWithPredicate<T: NSManagedObject>(_ predicate : NSPredicate) -> [T] {
        
        let className =   NSStringFromClass(self).components(separatedBy: ".").last!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetchRequest.returnsObjectsAsFaults = faultsOn
        
        fetchRequest.predicate = predicate
        
        var  result = [T]()
        do {
            result  = try CoreRecord.shared.persistentContainer.viewContext.fetch(fetchRequest) as! [T]
            
        } catch {
            print(error)
        }
        return result
    }
    
    class func findAllWithPredicate<T: NSManagedObject>(_ predicate : NSPredicate, sortedBy: [NSSortDescriptor]) -> [T] {
        
        let className =   NSStringFromClass(self).components(separatedBy: ".").last!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetchRequest.returnsObjectsAsFaults = faultsOn
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = sortedBy
        
        var  result = [T]()
        do {
            result  = try CoreRecord.shared.persistentContainer.viewContext.fetch(fetchRequest) as! [T]
            
        } catch {
            print(error)
        }
        return result
    }
    
    func delete() {
        
        CoreRecord.shared.persistentContainer.viewContext.delete(self)
        
    }
}



