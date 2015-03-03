//
//  TagCell.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/2/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

  static let reuseIdentifier = "TagCell"

  @IBOutlet weak var tagLabel: UILabel!

  @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.cornerRadius = self.tagLabel.font.lineHeight * 0.75
    self.clipsToBounds = true
    updateColors()
  }

  override func tintColorDidChange() {
    updateColors()
  }

  override func updateConstraints() {
    leadingConstraint.constant = self.layer.cornerRadius
    trailingConstraint.constant = self.layer.cornerRadius
    topConstraint.constant = tagLabel.font.lineHeight * 0.3
    bottomConstraint.constant = tagLabel.font.lineHeight * 0.3

    super.updateConstraints()
  }

  func updateColors() {
    self.backgroundColor = self.tintColor
    tagLabel.textColor = UIColor.whiteColor()
  }

}
