//
//  FaceViewController.swift
//  Face Flash
//
//  Created by David Vanoni on 1/17/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class FaceViewController: UITableViewController, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  var face: Face!

  private var activeTextView: UITextView?
  private var activeTextViewPrevHeight: CGFloat?

  @IBOutlet var textEditDoneButton: UIBarButtonItem!

  private enum Section: Int {
    case Face = 0, Facts
    static let count = 2
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.rightBarButtonItem = self.editButtonItem()

    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 44.0

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)

    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    // Refresh table view layout
    self.tableView.beginUpdates()
    self.tableView.endUpdates()
  }

  func contentSizeCategoryChanged(notification: NSNotification) {
    self.tableView.reloadData()
  }

  // MARK: - Actions

  @IBAction func editFaceImage(sender: AnyObject) {
    self.startImagePicker()
  }

  @IBAction func textEditDone(sender: AnyObject) {
    if let textView = self.activeTextView {
      textView.resignFirstResponder()
    }
  }

  // MARK: - Helper methods

  // Delete the contents of the text view and reset its style
  private func setupFactTextView(textView: FactTextView) {
    textView.text = ""
    textView.style = .Default
  }

  // Set the contents of the text view to "Add Fact..." and set its style
  private func setupAddFactTextView(textView: FactTextView) {
    textView.text = "Add Fact..."
    textView.style = .Add
  }

  private func indexPathForTextView(textView: UITextView) -> NSIndexPath? {
    if let cell = textView.superview?.superview as? FactCell {
      if let indexPath = self.tableView.indexPathForCell(cell) {
        return indexPath
      }
    }
    return nil
  }

  private func startImagePicker() -> Bool {
    if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
      return false
    }

    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    // By default imagePicker.mediaTypes = [kUTTypeImage], which is what we want
    imagePicker.allowsEditing = true
    imagePicker.delegate = self

    self.presentViewController(imagePicker, animated: true, completion: nil)

    return true
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return Section.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    switch Section(rawValue: section)! {
    case .Face:
      return 1
    case .Facts:
      return self.face.factArray.count + 1
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Configure the cell...
    switch Section(rawValue: indexPath.section)! {
    case .Face:
      let faceCell = tableView.dequeueReusableCellWithIdentifier(FaceCell.reuseIdentifier, forIndexPath: indexPath) as! FaceCell
      faceCell.updateFonts()
      faceCell.nameTextField.text = self.face.fullName
      if let image = self.face.imageQ {
        faceCell.faceImageView.image = image
      }
      else {
        faceCell.imageEditButton.setTitle("Add Photo", forState: .Normal)
      }
      return faceCell
    case .Facts:
      let factCell = tableView.dequeueReusableCellWithIdentifier(FactCell.reuseIdentifier, forIndexPath: indexPath) as! FactCell
      if indexPath.row < self.face.factArray.count {
        setupFactTextView(factCell.factTextView)
        factCell.factTextView.text = self.face.factArray[indexPath.row]
      }
      else {
        setupAddFactTextView(factCell.factTextView)
      }
      return factCell
    }
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch Section(rawValue: section)! {
    case .Facts:
      return "Facts"
    default:
      return nil
    }
  }

  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    switch Section(rawValue: indexPath.section)! {
    case .Face:
      return true
    case .Facts:
      return indexPath.row < self.face.factArray.count
    }
  }

  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // Delete the row from the data source
      self.face.factArray.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }

  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    self.face.factArray.insert(self.face.factArray.removeAtIndex(fromIndexPath.row), atIndex: toIndexPath.row)
  }

  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    switch Section(rawValue: indexPath.section)! {
    case .Face:
      return false
    case .Facts:
      return indexPath.row < self.face.factArray.count
    }
  }

  // MARK: - Table view delegate

  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    switch Section(rawValue: indexPath.section)! {
    case .Face:
      return .None
    case .Facts:
      return .Delete
    }
  }

  override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    switch Section(rawValue: indexPath.section)! {
    case .Face:
      return false
    case .Facts:
      return true
    }

  }

  override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
    if sourceIndexPath.section != proposedDestinationIndexPath.section {
      // Do not let a fact be moved out of the Facts section
      let rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section) ? 0 : self.face.factArray.count - 1
      return NSIndexPath(forRow: rowInSourceSection, inSection: sourceIndexPath.section)
    }
    else if proposedDestinationIndexPath.row >= self.face.factArray.count {
      // Do not let a fact be moved to the last position - this is reserved for the "Add Fact..." placeholder
      return NSIndexPath(forRow: self.face.factArray.count - 1, inSection: sourceIndexPath.section)
    }
    // Allow the proposed destination
    return proposedDestinationIndexPath
  }

  // MARK: - Collection view data source

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.face.tagArray.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let tagCell = collectionView.dequeueReusableCellWithReuseIdentifier(TagCell.reuseIdentifier, forIndexPath: indexPath) as! TagCell
    tagCell.tagLabel.text = self.face.tagArray[indexPath.item]
    return tagCell
  }

  // MARK: - Text field delegate

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    // Dismiss keyboard when return key is pressed
    textField.resignFirstResponder()
    return false
  }

  func textFieldDidEndEditing(textField: UITextField) {
    // TODO: Save changes to name
    println("set name to: \(textField.text)")
  }

  // MARK: - Text view delegate

  func textViewDidBeginEditing(textView: UITextView) {
    self.activeTextView = textView
    self.activeTextViewPrevHeight = textView.intrinsicContentSize().height

    // Ensure the table view's editing mode is not active
    self.setEditing(false, animated: true)

    // Set up the Done button for exiting text editing
    self.navigationItem.setRightBarButtonItem(self.textEditDoneButton, animated: false)

    if indexPathForTextView(textView)?.row >= self.face.factArray.count {
      // This is the "Add Fact..." text view
      // Delete the contents and reset the text style
      setupFactTextView(textView as! FactTextView)
    }
  }

  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    // Dismiss keyboard when return key is pressed
    if text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) == nil {
      // No newline character found
      return true
    }
    else {
      // Newline character found
      textView.resignFirstResponder()
      return false
    }
  }

  func textViewDidChange(textView: UITextView) {
    let textViewHeight = textView.intrinsicContentSize().height

    if textViewHeight != self.activeTextViewPrevHeight {
      // Text view height has changed
      // Refresh table view to update height
      self.tableView.beginUpdates()
      self.tableView.endUpdates()
    }

    self.activeTextViewPrevHeight = textViewHeight
  }

  func textViewDidEndEditing(textView: UITextView) {
    self.activeTextView = nil
    self.activeTextViewPrevHeight = nil

    // Reset the Done button back to the default Edit button
    self.navigationItem.setRightBarButtonItem(self.editButtonItem(), animated: false)

    if let indexPath = self.indexPathForTextView(textView) {
      if indexPath.row < self.face.factArray.count {
        // An existing fact was edited
        self.face.factArray[indexPath.row] = textView.text
      }
      else if !textView.text.isEmpty {
        // A new fact was added
        self.face.addFact(textView.text)
        let newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
      }
      else {
        // No text was added to the new fact - reset text view
        setupAddFactTextView(textView as! FactTextView)
      }
    }
  }

  // MARK: - Image picker delegate

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    // Set edited image as new face image
    let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
    self.face.imageQ = editedImage

    // Reload face cell
    let faceCellIndexPath = NSIndexPath(forRow: 0, inSection: Section.Face.rawValue)
    self.tableView.reloadRowsAtIndexPaths([faceCellIndexPath], withRowAnimation: .None)

    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  }
  */

}
