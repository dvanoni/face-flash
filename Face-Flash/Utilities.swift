//
//  Utilities.swift
//  Face-Flash
//
//  Created by John Sadowsky on 3/7/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import Foundation
import UIKit


///////////////////////////////////////////////
// Extensions

// MARK: - String

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
        return ( self[self.startIndex..<ix], self[ix.successor()..<self.endIndex] )
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
  
  // SplitAtIndex: if self.startIndex <= ix <= start.endIndex, returns (head, tail) where
  //               head is self up to but not including ix, tail is self from ix inclusive,
  //               and either may be empty if ix is at start or end.
  //               returns nil for an invalid index
  func splitAtIndex(ix: String.Index) -> (head: String, tail:String)?
  {
    if self.isEmpty
    {
      return nil
    }
    else
    {
      if ix == self.startIndex
      {
        return ("",self)
      }
      else
      {
        if ix < self.endIndex
        {
          return ( self[self.startIndex..<ix], self[ix..<self.endIndex] )
        }
        else
        {
          if ix == self.endIndex
          {
            return (self,"")
          }
          else
          {
            return nil
          }
        }
      }
    }
  }
  
  // splitAroundRange is a generalization of splitAtIndex
  func splitAroundRange(range: Range<String.Index>) -> (head: String, tail:String)?
  {
    if let (head, _) = self.splitAtIndex(range.startIndex)
    {
      if let (_, tail) = self.splitAtIndex(range.endIndex)
      {
        return (head,tail)
      }
    }
    return nil
  }
  
}


// MARK: - UIView

extension UIView
{
  /// Add a single-pixel bottom border to the view using Auto Layout.
  ///
  /// :param: color The color of the border. Default is light gray.
  func addBottomBorder(color: UIColor = UIColor.lightGrayColor())
  {
    let border = UIView(frame: CGRectZero)
    border.backgroundColor = color
    border.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.addSubview(border)

    let borderWidth = 1.0 / UIScreen.mainScreen().scale

    // Set height constraint to borderWidth
    self.addConstraint(NSLayoutConstraint(item: border, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: borderWidth))

    // Add constraints to pin border to leading, trailing, and bottom edges of this view
    self.addConstraint(NSLayoutConstraint(item: border, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: border, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: border, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
  }
}


// MARK: - UITableView

extension UITableView
{
  /// Returns a Boolean value indicating whether the table-view has a row at the specified index path.
  ///
  /// :param: indexPath The index path to look for in the table-view.
  ///
  /// :returns: `true` if a row exists at `indexPath`, `false` otherwise.
  func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
    if indexPath.section < self.numberOfSections() {
      if indexPath.row < self.numberOfRowsInSection(indexPath.section) {
        return true
      }
    }
    return false
  }
}


// MARK: - UIColor

extension UIColor
{
  /// Return a color that is an interpolation between this color and `otherColor`,
  /// using `percentage` to determine the resulting interpolation amount.
  ///
  /// :param: otherColor The color to interpolate with this color.
  /// :param: percentage The percentage of this color to be interpolated with `otherColor`.
  ///                    This should be a value between 0.0 and 1.0, where 0.0 corresponds
  ///                    to using the `otherColor` entirely and 1.0 corresponds to using
  ///                    this color entirely.
  ///
  /// :returns: The interpolated color.
  func interpolateWithColor(otherColor: UIColor, percentage: CGFloat) -> UIColor {

    func interpolateValue(value: CGFloat, otherValue: CGFloat) -> CGFloat {
      return value * percentage + otherValue * (1.0 - percentage)
    }

    var hue1: CGFloat = 1.0, saturation1: CGFloat = 1.0, brightness1: CGFloat = 1.0, alpha1: CGFloat = 1.0
    var hue2: CGFloat = 1.0, saturation2: CGFloat = 1.0, brightness2: CGFloat = 1.0, alpha2: CGFloat = 1.0

    self.getHue(&hue1, saturation: &saturation1, brightness: &brightness1, alpha: &alpha1)
    otherColor.getHue(&hue2, saturation: &saturation2, brightness: &brightness2, alpha: &alpha2)

    return UIColor(hue: interpolateValue(hue1, hue2), saturation: interpolateValue(saturation1, saturation2), brightness: interpolateValue(brightness1, brightness2), alpha: interpolateValue(alpha1, alpha2))
  }
}
