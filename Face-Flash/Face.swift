//
//  Face.swift
//  Face Flash
//
//  Created by John Sadowsky on 3/4/2015.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//


import UIKit
import CoreData


class FaceArray {
  
  // Singleton Control
  static private var _onceToken : dispatch_once_t = 0
  static private var _instance : FaceArray? = nil
  
  static var sharedInstance : FaceArray
  {
    dispatch_once( &FaceArray._onceToken )
    {
      FaceArray._instance = FaceArray()
    }
    return FaceArray._instance!
  }

  
  private var _array: Array<FaceBase> = []

  private init() {}

  subscript(index: Int) -> FaceBase
    {
    return _array[index]
  }

  var count: Int {
    return self._array.count
  }
  
  func addFace(face: FaceBase) -> Bool
  {
    _array.append(face)
    return true
  }
  
  func setFaces()
  {
    
    var error: NSError? = nil
    
    if let moc = FF_CoreData.sharedInstance.managedObjectContext
    {
      
      // Test Block - resets persistent store - false to test Core Data fetch
      if false
      {
        if let psc = moc.persistentStoreCoordinator
        {
          if let psa = psc.persistentStores as? [NSPersistentStore]
          {
            assert(psa.count == 1)
            if !moc.persistentStoreCoordinator!.removePersistentStore(psa[0], error: &error)
            {
              println("FaceArray: setFaces failed to remove persistent store")
              abort()
            }
            if psc.addPersistentStoreWithType( NSSQLiteStoreType, configuration: nil,
               URL: FF_CoreData.sharedInstance.persistentStoreURL, options: nil, error: &error) == nil
            {
              println("FaceArray: setFaces failed to create new persistent store")
              abort()
            }
          }
        }
      }
      
      var fetchRequest = NSFetchRequest()
      fetchRequest.entity = NSEntityDescription.entityForName("FaceBase", inManagedObjectContext: moc )
      var error: NSError? = nil
      
      if let fetchedObjects = moc.executeFetchRequest(fetchRequest, error: &error)
      {
    
        if fetchedObjects.isEmpty
        {
          addHardCodedFaces()
          if !moc.save(&error)
          {
            println("FaceArray: setFaces failed to save managedObjectContext")
            abort()
          }
        }
        else
        {
          self._array = []
          for fx in fetchedObjects
          {
            if let fz = fx as? FaceBase
            {
              self._array.append(fz)
            }
            else
            {
              println("FaceArray.setFaces failed to cast AnyObject to FaceBase")
              abort()
            }
          }
        }
  
      }
      else
      {
        println("FaceArray: Core Data Fetch failed")
        abort()
      }
  
    }
    else
    {
      println("FaceArray: Failed to get managedObjectContext")
      abort()
    }

  }

}


////////////////////////////////////////////////////////////////////////
// MARK: - Base Interface Class

class FaceBase: NSManagedObject {
  
  
  var  firstName: String { return "firstName" }
  var middleName: String { return "middleName" }
  var   lastName: String { return "lastName" }
  var   fullName: String { return "fullName" }
  
  var  image: UIImage?
  {
    get
    {
      if imageStored.length < 32  // Kludge: If there is no image, the NSData object should be empty
      {
        return nil
      }
      else
      {
        return UIImage( data: imageStored )
      }
    }
    set
    {
      if let image = newValue
      {
        self.setValue( UIImagePNGRepresentation(image), forKey: "imageStored")
      }
      else
      {
        self.setValue( NSData(), forKey: "imageStored")
      }
    }
  }
  
  @NSManaged var imageStored: NSData
  //  @NSManaged var   factArray: Array<String>
  var   factArray: Array<String> = []
  
  // This override initializer is needed for Core Data fetch
  private override init( entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext? )
  {
    super.init( entity: entity, insertIntoManagedObjectContext: context)
  }
  
  private init( imageQ: UIImage?, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext? )
  {
    
    super.init( entity: entity, insertIntoManagedObjectContext: context)
    
    if let image = imageQ
    {
      self.setValue( UIImagePNGRepresentation(image), forKey: "imageStored")
    }
    else
    {
      self.setValue( NSData(), forKey: "imageStored")
    }
    
  }


  func addFact(fact: String) {
    factArray.append(fact)
  }

}


// MARK: - Implementation Classes

class FF_Face: Face_Flash.FaceBase
{
  
  @NSManaged private var  firstNameStored: String
  @NSManaged private var middleNameStored: String
  @NSManaged private var   lastNameStored: String
  
  override var  firstName: String { return self.firstNameStored }
  override var middleName: String { return self.middleNameStored }
  override var   lastName: String { return self.lastNameStored }
  
  override var   fullName: String
  {
    if middleName.isEmpty
    {
      return self.firstNameStored + " " + self.lastNameStored
    }
    else
    {
      return self.firstNameStored + " " + self.middleNameStored + " " + self.lastNameStored
    }
  }
  
  // This override initializer is needed for Core Data fetch
  private override init( entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext? )
  {
    super.init( entity: entity, insertIntoManagedObjectContext: context)
  }

  init( firstName: String, middleNameQ: String?, lastName: String, imageQ: UIImage? )
  {
    
    if let moc = FF_CoreData.sharedInstance.managedObjectContext
    {
      if let ed = NSEntityDescription.entityForName( "FF_Face", inManagedObjectContext: moc )
      {
        super.init( imageQ: imageQ, entity: ed, insertIntoManagedObjectContext: moc )
      }
      else
      {
        println("FF_Face.init: failed to get entity description")
        abort()
      }
    }
    else
    {
      println("FF_Face.init: managedObjectContext failed")
      abort()
    }
    
    self.setValue(firstName, forKey: "firstNameStored")
    self.setValue( lastName, forKey: "lastNameStored")
    
    if let mn = middleNameQ
    {
      self.setValue( mn, forKey: "middleNameStored")
    }
    else
    {
      self.setValue( "", forKey: "middleNameStored")
    }

  }
  


}

//private class Contact_Face: Face
//{
//  // TODO: Connect to an Address Book Record (ABRecord)
//
//  private init(_ firstName: String, _ middleNameQ: String?, _ lastName: String, _ imageQ: UIImage?) {
//    super.init(imageQ: imageQ)
//  }
//}
