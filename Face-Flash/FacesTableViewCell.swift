//
//  FacesTableViewCell.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/2/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FacesTableViewCell: UITableViewCell {

  static let reuseIdentifier = "FaceCell"

  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    faceImageView.layer.cornerRadius = faceImageView.frame.height * 0.5
    updateColors()
  }

  override func tintColorDidChange() {
    updateColors()
  }

  func updateColors() {
    faceImageView.tintColor = self.tintColor
  }

}
