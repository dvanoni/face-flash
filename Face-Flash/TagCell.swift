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

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.borderWidth = 1.0

    updateColors()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height * 0.5
  }

  override func tintColorDidChange() {
    updateColors()
  }

  func updateColors() {
    self.backgroundColor = self.tintColor.colorWithAlphaComponent(0.1)
    self.layer.borderColor = self.tintColor.colorWithAlphaComponent(0.5).CGColor
  }

}
