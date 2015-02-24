//
//  HomeViewController.swift
//  Face Flash
//
//  Created by John Yu on 1/17/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // JSS: This is a temporary initialization
        addHardCodedFaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func presentStoryboard(name: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let initialController = storyboard.instantiateInitialViewController() as? UIViewController
        {
          self.presentViewController(initialController, animated: true, completion: nil)
        }
    }

    @IBAction func onFacesPressed(sender: UIButton) {
        presentStoryboard("Faces")
    }

    @IBAction func onQuizPressed(sender: UIButton) {
        presentStoryboard("Quiz")
    }

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
}

