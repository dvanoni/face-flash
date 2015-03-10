//
//  FaceCell.swift
//  Face Flash
//
//  Created by David Vanoni on 2/10/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FaceCell: UITableViewCell {

  static let reuseIdentifier = "FaceCell"

  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var imageEditContainerView: UIVisualEffectView!
  @IBOutlet weak var imageEditButton: UIButton!

  @IBOutlet weak var infoDisplayView: UIView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var tagsCollectionView: UICollectionView!

  @IBOutlet weak var infoEditView: UIView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    faceImageView.layer.cornerRadius = faceImageView.frame.height * 0.5
    faceImageView.addSubview(imageEditContainerView)

    if let flowLayout = self.tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      // Set estimated size to enable automatic cell sizing
      flowLayout.estimatedItemSize = CGSize(width: 40.0, height: 20.0)
    }

    updateColors()
    updateFonts()
  }

  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    imageEditContainerView.hidden = !editing

    // Determine which views to show/hide
    let fromView, toView: UIView
    if editing {
      fromView = self.infoDisplayView
      toView = self.infoEditView
    }
    else {
      fromView = self.infoEditView
      toView = self.infoDisplayView
      // Stop any text input
      self.endEditing(false)
    }

    let animationOptions: UIViewAnimationOptions = .ShowHideTransitionViews | .TransitionCrossDissolve

    UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: animationOptions, completion: nil)
  }

  override func tintColorDidChange() {
    updateColors()
  }

  func updateColors() {
    faceImageView.tintColor = self.tintColor
  }

  func updateFonts() {
    fullNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    firstNameTextField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    lastNameTextField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
  }

}
