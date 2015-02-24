//
//  FactCell.swift
//  Face Flash
//
//  Created by David Vanoni on 2/12/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FactCell: UITableViewCell {

    @IBOutlet weak var factTextView: FactTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
