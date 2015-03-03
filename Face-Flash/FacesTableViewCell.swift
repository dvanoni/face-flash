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
  @IBOutlet weak var faceImageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var nameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    self.faceImageView.layer.cornerRadius = self.faceImageViewHeightConstraint.constant * 0.5
  }

}
