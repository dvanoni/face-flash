//
//  Face.swift
//  Face Flash
//
//  Created by John Yu on 1/17/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

private var _faceArray = FaceArray()

class FaceArray {

  private var array: Array<Face> = []

  private init() {}

  subscript(index: Int) -> Face {
    return array[index]
  }

  var count: Int {
    return array.count
  }

  class func getArray() -> FaceArray {
    return _faceArray
  }

  func addFace(face: Face) -> Bool {
    array.append(face)
    return true
  }
}


// MARK: - Base Interface Class

class Face {

  var firstName: String {
    return ""
  }
  var middleName: String? {
    return nil
  }
  var lastName: String {
    return ""
  }

  var fullName: String {
    if let mn = middleName {
      return firstName + " " + mn + " " + lastName
    }
    else {
      return firstName + " " + lastName
    }
  }

  var imageQ: UIImage?

  var factArray: Array<String> = []

  private init(imageQ: UIImage?) {
    self.imageQ = imageQ
  }

  // Factory methods
  class func makeFF_Face(#firstName: String, middleNameQ: String?, lastName: String, imageQ: UIImage?) -> Face {
    return FF_Face(firstName, middleNameQ, lastName, imageQ)
  }

  class func makeContact_Face(firstName: String, middleNameQ: String?, lastName: String, imageQ: UIImage?) -> Face {
    return Contact_Face(firstName, middleNameQ, lastName, imageQ)
  }

  func addFact(fact: String) {
    factArray.append(fact)
  }
}


// MARK: - Implementation Classes

private class FF_Face: Face
{
  let   _firstName: String
  let _middleNameQ: String?
  let    _lastName: String

  override var firstName: String {
    return _firstName
  }
  override var middleName: String? {
    return _middleNameQ
  }
  override var lastName: String {
    return _lastName
  }

  private init(_ firstName: String, _ middleNameQ: String?, _ lastName: String, _ imageQ: UIImage?) {
    self._firstName   = firstName
    self._middleNameQ = middleNameQ
    self._lastName    = lastName
    super.init(imageQ: imageQ)
  }
}

private class Contact_Face: Face
{
  // TODO: Connect to an Address Book Record (ABRecord)

  private init(_ firstName: String, _ middleNameQ: String?, _ lastName: String, _ imageQ: UIImage?) {
    super.init(imageQ: imageQ)
  }
}
