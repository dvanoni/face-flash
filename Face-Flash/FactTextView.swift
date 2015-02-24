//
//  FactTextView.swift
//  Face Flash
//
//  Created by David Vanoni on 2/22/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

private let defaultColor = UIColor.darkTextColor()
private let addColor     = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)

class FactTextView: UITextView {

    enum TextStyle {
        case Default, Add
    }

    var style: TextStyle = .Default {
        didSet {
            switch self.style {
            case .Default:
                self.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                self.textColor = defaultColor
            case .Add:
                self.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                self.textColor = addColor
            }
        }
    }
}
