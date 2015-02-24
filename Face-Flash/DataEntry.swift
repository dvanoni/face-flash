//
//  DataEntry.swift
//  Face Flash
//
//  Created by John S Sadowsky on 1/25/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

func addHardCodedFaces()
{
    let faceArray = FaceArray.getArray()
    var face: Face
    
    
    face = Face.makeFF_Face( firstName: "John", middleNameQ: "S", lastName: "Sadowsky", imageQ: (UIImage (named: "jSadowsky")) )
    
    face.addFact("Hobby: Photography")
    face.addFact("Married to Gabrielle")
    face.addFact("two daughters, Danielle and Clarissa")
    face.addFact("Profession: Semi-retired as Wireless systems engineer")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "Simon", middleNameQ: nil, lastName: "Choi", imageQ: (UIImage (named: "sChoi")) )
    
    face.addFact("ASU Graduate")
    face.addFact("Boy")
    face.addFact("Software Developer")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "David", middleNameQ: nil, lastName: "Vanoni", imageQ: (UIImage (named: "dVanoni")) )
    
    face.addFact("Went to school in UC San Diego")
    face.addFact("Lives in Tempe")
    face.addFact("Knows Swift")
    face.addFact("1 Lots and lots and lots and lots and lots and lots and lots and lots and lots and lots and lots of text")
    face.addFact("2 Lots and lots and lots and lots and lots and lots and lots and lots and lots and lots and lots of text")
    face.addFact("3 Lots and lots and lots and lots and lots and lots and lots and lots and lots and lots and lots of text")
    face.addFact("4 Lots and lots and lots and lots and lots and lots and lots and lots and lots and lots and lots of text")
    face.addFact("5 Lots and lots and lots and lots and lots and lots and lots and lots and lots and lots and lots of text")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "Melody", middleNameQ: nil, lastName: "Hunsinger", imageQ: (UIImage (named: "mHunsinger")) )
    
    face.addFact("Went to UK")
    face.addFact("Degree in technology")
    face.addFact("Went to University of Kentucky")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "Albert", middleNameQ: nil, lastName: "Prano", imageQ: (UIImage (named: "aPrano")) )
    
    face.addFact("Web Developer")
    face.addFact("Graphic Designer")
    face.addFact("Lives in Gilbert")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "Derek", middleNameQ: nil, lastName: "Harris", imageQ: (UIImage (named: "dHarris")) )
    
    face.addFact("Worked with Bill Clinton")
    face.addFact("Travels alot")
    face.addFact("Fact 3")
    
    faceArray.addFace(face)
    
    
    face = Face.makeFF_Face( firstName: "John", middleNameQ: nil, lastName: "Yu", imageQ: (UIImage (named: "jYu")) )
    
    face.addFact("iOS Developer")
    face.addFact("From Taiwan")
    face.addFact("ASU student")
    
    faceArray.addFace(face)
}

        
