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
  
  @NSManaged var imageStored: NSData
  @NSManaged var factsStored: String
  
  // Tempory Variables (unmanaged working variables)
  private var    factsQ: String? = nil
  private var factsFlag: Bool = false
  
  private func getFacts() -> String
  {
    if self.factsQ == nil
    {
      if let fx = self.valueForKey("factsStored") as? String
      {
        self.factsQ = fx
      }
      else
      {
        self.factsQ = ""
      }
    }
    return self.factsQ!
  }
  
  // Computed Properties
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
  
  // computed get only property
  var   factArray: Array<String>
  {
    var fa: Array<String> = []
    let facts = getFacts()
    for fact in facts.sliceSequenceByCharacter("\n")
    {
      fa.append(fact)
    }
    return fa
  }
  
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
  
  
  //////////////////////////////////
  // Methods
  
  private func findFactIndexAtCount( count: Int ) -> (facts: String, index: String.Index)?
  {
  
    if count < 0 { return nil }
    
    let facts = self.getFacts()
    
    if facts.isEmpty { return nil }
  
    var i1 = facts.startIndex  // != facts.endIndex because facts is not empty
    for k in 0 ..< count
    {
      while (i1 != facts.endIndex) && (facts[i1] != "\n") { i1 = i1.successor() }
      if i1 == facts.endIndex { return nil }
    }

    return (facts, i1)
    
  }
  
  // Note:  findFactAtIndex does not return facts.endIndex, that is a nil return.
  //        There must be an actual found fact to not return nil
  private func findFactRangeAtCount( ix: Int ) -> (facts: String, Range<String.Index>)?
  {

    if let (facts, i) = findFactIndexAtCount(ix)
    {
      
      var i1 = i

      assert(facts[i1] == "\n")
      i1 = i1.successor()
      assert(i1 != facts.endIndex) // There should not be a newline at the end of the facts string
 
      var i2 = i1
      while (i2 != facts.endIndex) && (facts[i2] != "\n") { i2 = i2.successor() }

      return ( facts, Range<String.Index>( start: i1, end: i2 ) )

    }

    return nil
    
  }
  
  ///////////////////////////
  // Interface methods
  
  func addFact(newFact: String)
  {
    let facts = getFacts()
    if facts.isEmpty
    {
      self.factsQ    = newFact
    }
    else
    {
      self.factsQ = facts + "\n" + newFact
    }
    self.factsFlag = true
  }
  
  func removeFactAtIndex( ix: Int ) -> String?
  {

    if let (facts, factRange) = findFactRangeAtCount(ix)
    {
      let fact = facts[factRange]
      if let (head, tail) = facts.splitAroundRange(factRange)
      {
        if head.isEmpty
        {
          self.factsQ = tail[ tail.startIndex.successor() ..< tail.endIndex ]           // remove leading "\n" on tail
        }
        else
        {
          self.factsQ = head[ head.startIndex ..< head.endIndex.predecessor() ] + tail  // remove trailing "\n" on head
        }
        self.factsFlag = true
        return fact
      }
    }
    
    return nil
    
  }
  
  func insertFactAtIndex( ix: Int, newFact: String ) -> Bool
  {
    
    if let (facts, i) = findFactIndexAtCount(ix)
    {
      if i == facts.startIndex
      {
        self.factsQ = newFact + "\n" + facts
        self.factsFlag = true
        return true
      }
      else
      {
        if let (head, tail) = facts.splitAtIndex(i)
        {
          assert(!head.isEmpty)
          self.factsQ = head + "\n" + newFact + tail
          self.factsFlag = true
          return true
        }
      }
    }

    return false

  }

  func changeFactAtIndex( ix: Int, changedFact: String ) -> Bool
  {
  
    if let (facts, factRange) = findFactRangeAtCount(ix)
    {
      if let (head, tail) = facts.splitAroundRange(factRange)
      {
        self.factsQ = head + changedFact + tail
        self.factsFlag = true
        return true
      }
    }
    return false
  
  }
  
  func prepareForStore()
  {
    if self.factsFlag
    {
      let facts = self.getFacts()
      self.setValue(facts, forKey: "factsStored")
      self.factsFlag = false
    }
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
