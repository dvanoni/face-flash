//
//  FacesNavigationController.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/1/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FacesNavigationController: UINavigationController {

  @IBOutlet weak var facesTabBarItem: UITabBarItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBarItem = facesTabBarItem
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
