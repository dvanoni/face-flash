//
//  MainTabBarController.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/1/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set up the tab view controllers
    if let facesController = initialViewControllerForStoryboard("Faces"),
            quizController = initialViewControllerForStoryboard("Quiz")
    {
      self.viewControllers = [facesController, quizController]
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func initialViewControllerForStoryboard(name: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    return storyboard.instantiateInitialViewController() as? UIViewController
  }


  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
