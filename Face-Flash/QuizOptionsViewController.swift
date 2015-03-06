//
//  QuizOptionsViewController.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/1/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class QuizOptionsViewController: UITableViewController {

  private let faceArray = FaceArray.getArray()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Actions

  @IBAction func unwindToQuizOptions(segue: UIStoryboardSegue) {
    
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      // TODO: Use proper collection of tags
      return faceArray[0].tagArray.count
    case 1:
      return 1
    default:
      return 0
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let tagCell = tableView.dequeueReusableCellWithIdentifier("TagCell", forIndexPath: indexPath) as! UITableViewCell
      // TODO: Use proper collection of tags
      tagCell.textLabel?.text = faceArray[0].tagArray[indexPath.row]
      return tagCell
    case 1:
      return tableView.dequeueReusableCellWithIdentifier("StartQuizCell", forIndexPath: indexPath) as! UITableViewCell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Select Tags"
    default:
      return nil
    }
  }

  // MARK: Table view delegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)

    if let cell = tableView.cellForRowAtIndexPath(indexPath) where indexPath.section == 0 {
      if cell.accessoryType == .None {
        cell.accessoryType = .Checkmark
      }
      else {
        cell.accessoryType = .None
      }
    }
  }

}
