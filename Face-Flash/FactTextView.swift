//
//  FactTextView.swift
//  Face Flash
//
//  Created by David Vanoni on 2/22/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FactTextView: UITextView {

  enum TextStyle {
    case Default, Add
  }

  var style: TextStyle = .Default {
    didSet {
      switch self.style {
      case .Default:
        self.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        self.textColor = UIColor.darkTextColor()
      case .Add:
        self.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        self.textColor = self.tintColor
      }
    }
  }

  override func tintColorDidChange() {
    if self.style == .Add {
      self.textColor = self.tintColor
    }
  }

}
