//
//  CoreData.swift
//  Face-Flash
//
//  Created by John Sadowsky on 3/4/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import Foundation
import CoreData

class FF_CoreData
{
  
  // Singleton Control

  static private var _onceToken : dispatch_once_t = 0
  static private var _instance : FF_CoreData? = nil
  
  class var sharedInstance : FF_CoreData
  {
    dispatch_once( &FF_CoreData._onceToken )
    {
      FF_CoreData._instance = FF_CoreData()
    }
    return FF_CoreData._instance!
  }

  // The directory the application uses to store the Core Data store file.
  // This code uses a directory named "com.xxxx.ProjectName" in the application'sdocuments Application Support directory.

  let documentsDirectory: NSURL
  let persistentStoreURL: NSURL


  // The managed object model for the application.
  // This property is not optional. It is a fatal error for the application not to be able to find and load its model.

  var managedObjectModel: NSManagedObjectModel

  // The persistent store coordinator for the application.
  // This implementation creates and return a coordinator, having added the store for the application to it.
  // This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
  // Create the coordinator and store

  var persistentStoreCoordinator: NSPersistentStoreCoordinator?

  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  // This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.

  var managedObjectContext: NSManagedObjectContext?
  
  // MARK: - Core Data Saving support
  
  func saveContext ()
  {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error), \(error!.userInfo)")
        abort()
      }
    }
  }
  
  // MARK: - Fetch Faces
  
//  func fetch()
//  {
//    
//    if let managedObjectContext = FF_CoreData.sharedInstance.managedObjectContext
//    {
//    
//      var fetchRequest = NSFetchRequest()
//      fetchRequest.entity = NSEntityDescription.entityForName("FaceBase", inManagedObjectContext: managedObjectContext )
//      
//      var error: NSError? = nil
//      
//      if var fetchedObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
//      {
//        FaceArray.setFaces(fetchedObjects)
//      }
//      
//    }
//    else
//    {
//      println("Fetch failed because managedObjectContext == nil")
//    }
//    
//  }


  // Initializer
  
  private init()
  {
  
    // set documentsDirectory
    let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask )
    if let url = urls[urls.count-1] as? NSURL
    {

      self.documentsDirectory = url
      self.persistentStoreURL = url.URLByAppendingPathComponent("FaceFlash.sqlite")
      
      // Reset block
      if true
      {
        let fm = NSFileManager()
        var error: NSError? = nil
        fm.removeItemAtURL(self.persistentStoreURL, error: &error)
        fm.removeItemAtURL(url.URLByAppendingPathComponent("FaceFlash.sqlite-shm"), error: &error)
        fm.removeItemAtURL(url.URLByAppendingPathComponent("FaceFlash.sqlite-wal"), error: &error)
      }

    }
    else
    {
      println("Failed to get faceFlashDocumentsDirectory URL");
      abort()
    }

    if let mom = NSManagedObjectModel.mergedModelFromBundles(nil)
    {
      self.managedObjectModel = mom
    }
    else
    {
      println("Failed to create managedObjectModel")
      abort()
    }
  
    // create coordinator
  
    var error: NSError? = nil
    
    self.persistentStoreCoordinator = NSPersistentStoreCoordinator( managedObjectModel: self.managedObjectModel )

    if let psc = self.persistentStoreCoordinator
    {
      
      if psc.addPersistentStoreWithType( NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreURL, options: nil, error: &error) == nil
      {
    
        // Report any error we got.
        var dict: Dictionary<NSObject, AnyObject> = [:]
        dict[NSLocalizedDescriptionKey]        = "Failed to initialize the application's saved data"
        dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
        dict[NSUnderlyingErrorKey]             = error
    
        error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate.
        // You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error), \(error!.userInfo)")
        abort()
    
      }
    
      self.managedObjectContext = NSManagedObjectContext()
      
      if let moc = self.managedObjectContext
      {
        
        moc.persistentStoreCoordinator = psc
        
      }
      else
      {
        println("Failed to create managedObjectContext")
        abort()
      }
    }
    else
    {
      println("Failed to create persistentStoreCoordinator")
      abort()
    }
  
  }
  
}





