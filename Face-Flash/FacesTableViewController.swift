//
//  FacesTableViewController.swift
//  Face Flash
//
//  Created by Simon Choi on 1/17/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FacesTableViewController: UITableViewController {

  private let faceArray = FaceArray.sharedInstance

  private var selectedIndexPath: NSIndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Enable automatic row sizing
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 77.0

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    // Reload selected row when returning from detail view
    if let indexPath = selectedIndexPath where tableView.hasRowAtIndexPath(indexPath) {
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    selectedIndexPath = nil
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    if section == 0 {
      return faceArray.count
    }
    return 0
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(FacesTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! FacesTableViewCell

    // Configure the cell...
    cell.nameLabel.text = faceArray[indexPath.row].fullName
    if let image = faceArray[indexPath.row].image {
      cell.faceImageView.image = image
    }
    else {
      cell.faceImageView.image = UIImage(named: "FaceCellIcon")
    }

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedIndexPath = indexPath
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // Delete the row from the data source
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
  }
  */


  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowFace" {
      // Pass the selected Face to the new view controller
      let possibleRow = self.tableView.indexPathForSelectedRow()?.row
      let possibleController = segue.destinationViewController as? FaceViewController
      if let selectedRow = possibleRow, faceViewController = possibleController {
        faceViewController.face = faceArray[selectedRow]
      }
    }
  }

}
