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
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var tagsCollectionView: UICollectionView!

  override func awakeFromNib() {
    super.awakeFromNib()

    if let flowLayout = self.tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      // Set estimated size to enable automatic cell sizing
      flowLayout.estimatedItemSize = CGSize(width: 40.0, height: 20.0)
    }
    
    updateFonts()
  }

  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    imageEditContainerView.hidden = !editing
    nameTextField.enabled = editing
    nameTextField.borderStyle = editing ? .RoundedRect : .None
  }

  func updateFonts() {
    nameTextField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
  }

}
