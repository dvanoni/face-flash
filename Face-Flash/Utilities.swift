//
//  Utilities.swift
//  Face-Flash
//
//  Created by John Sadowsky on 3/7/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import Foundation


///////////////////////////////////////////////
// Extensions

extension String
{
  
  // This method splits a string at the first instance of Character c.  c is not
  // part of the split pair. The returned pair should be slices of the self, so no new strings
  // are actually created.
  // If c is not found in self, the function returns nil
  
  func splitAtFirstCharacter(c: Character) -> (head: String, tail: String?)
  {
    for var ix = self.startIndex; ix != self.endIndex; ix = ix.successor()
    {
      if self[ix] == c
      {
        return ( self[self.startIndex...ix], self[ix.successor()...self.endIndex] )
      }
    }
    return (self, nil)
  }
  
  // This is Generator for a sequence of slices created by the splitAtFirstCharactor method
  struct CharacterSliceGenerator: GeneratorType
  {
    
    typealias Element = String
    
    let    c: Character
    var tail: String?
    
    init( c: Character, str: String)
    {
      self.c    = c
      self.tail = str
    }
    
    mutating func next() -> Element?
    {
      if let t = self.tail
      {
        let p = t.splitAtFirstCharacter(c)
        self.tail = p.tail
        return p.head
      }
      else
      {
        return nil
      }
    }
  }
  
  
  struct CharacterSliceSequence: SequenceType
  {
    
    typealias Generator = CharacterSliceGenerator
    
    let str: String
    let   c: Character
    
    // hide default initializer
    private init()
    {
      self.str = ""; self.c = " "
    }
    
    init( c: Character, str: String)
    {
      self.str = str
      self.c   = c
    }
  
    func generate() -> Generator {
      return CharacterSliceGenerator(c: self.c, str: self.str )
    }

  }
  
  // New instance method to return a CharacterSliceGenerator for self string
  func sliceSequenceByCharacter( c: Character ) -> CharacterSliceSequence
  {
    return CharacterSliceSequence( c: c, str: self )
  }
  
}

