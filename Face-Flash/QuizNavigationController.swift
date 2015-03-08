//
//  QuizNavigationController.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/3/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class QuizNavigationController: UINavigationController {

  @IBOutlet weak var quizTabBarItem: UITabBarItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBarItem = quizTabBarItem
  }

}
