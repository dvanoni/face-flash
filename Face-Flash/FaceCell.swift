//
//  FaceCell.swift
//  Face Flash
//
//  Created by David Vanoni on 2/10/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FaceCell: UITableViewCell {

  static let cellIdentifier = "FaceCell"

  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var imageEditContainerView: UIVisualEffectView!
  @IBOutlet weak var imageEditButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    updateFonts()
  }

  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    imageEditContainerView.hidden = !editing
  }

  func updateFonts() {
    nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
  }
}
