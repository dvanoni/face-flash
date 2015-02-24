//
//  QuizViewController.swift
//  Face Flash
//
//  Created by John S Sadowsky on 1/17/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

private func makeFactAttributes() -> Dictionary<NSObject, AnyObject>
{

  let factFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

  var paragraphStyle = NSMutableParagraphStyle()

  paragraphStyle.paragraphSpacing = 0.5 * factFont.pointSize

  return [           NSFontAttributeName : factFont ,
    NSParagraphStyleAttributeName : paragraphStyle ]

}

private var index = -1

private let nameFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)

private let factAttributes = makeFactAttributes()


class QuizFactViewController: UIViewController {

  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var factTextView: UITextView!

  let fArray = FaceArray.getArray()

  override func viewDidLoad()
  {

    super.viewDidLoad()

    if (index >= 0) && (index < fArray.count)
    {

      let face = fArray[index]

      nameLabel.text = face.fullName
      nameLabel.font = nameFont

      var factString = ""

      for fact in face.factArray
      {
        factString += fact + "\n"
      }

      factTextView.attributedText = NSAttributedString(string: factString, attributes: factAttributes)

    }
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}

class QuizImageViewController: UIViewController
{

  @IBOutlet var imageView: UIImageView!

  let fArray = FaceArray.getArray()

  override func viewDidLoad()
  {

    super.viewDidLoad()

    ++index
    if index >= fArray.count
    {
      index = 0
    }

    if (index >= 0) && (index < fArray.count)
    {

      let face = fArray[index]
      if let image = face.imageQ
      {
        imageView.image = image
      }

    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
