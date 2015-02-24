//
//  FaceCell.swift
//  Face Flash
//
//  Created by David Vanoni on 2/10/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FaceCell: UITableViewCell {
    
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        updateFonts()
    }

    func updateFonts()
    {
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
}
