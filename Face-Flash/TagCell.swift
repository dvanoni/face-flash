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
    self.backgroundColor = self.tintColor
    self.tagLabel.textColor = UIColor.whiteColor()
  }

  override func tintColorDidChange() {
    self.backgroundColor = self.tintColor
  }

  override func updateConstraints() {
    self.leadingConstraint.constant = self.layer.cornerRadius
    self.trailingConstraint.constant = self.layer.cornerRadius
    self.topConstraint.constant = tagLabel.font.lineHeight * 0.3
    self.bottomConstraint.constant = tagLabel.font.lineHeight * 0.3

    super.updateConstraints()
  }

}
