//
//  QuizViewController.swift
//  Face-Flash
//
//  Created by David Vanoni on 3/3/15.
//  Copyright (c) 2015 Face Flash. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

  @IBOutlet weak var facesCountLabel: UILabel!

  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardFrontView: UIView!
  @IBOutlet weak var cardBackView: UIView!
  
  @IBOutlet weak var faceImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var factsTextView: UITextView!

  @IBOutlet weak var buttonsView: UIView!

  @IBOutlet var lineHeightConstraintCollection: [NSLayoutConstraint]!
  private let facesToShow = FaceArray.getArray().getShuffledArray()
  private var answers = [Bool]()


  private var progress: Float {
    return Float(answers.count) / Float(facesToShow.count)
  }
  private var countCorrect: Int {
    return answers.reduce(0) { sum, correct in sum + (correct ? 1 : 0) }
  }
  private var countIncorrect: Int {
    return answers.count - countCorrect
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    lineHeightConstraintCollection.map { constraint in
      constraint.constant = 1.0 / UIScreen.mainScreen().scale
    }

    cardFrontView.layer.cornerRadius = cardView.layer.cornerRadius
    cardBackView.layer.cornerRadius = cardView.layer.cornerRadius

    advanceQuiz()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Actions

  @IBAction func cardViewSwiped(sender: UISwipeGestureRecognizer) {
    var animationOptions: UIViewAnimationOptions = .allZeros

    if sender.direction == .Left {
      animationOptions = .TransitionFlipFromRight
    }
    else if sender.direction == .Right {
      animationOptions = .TransitionFlipFromLeft
    }

    showCardBackWithAnimationOptions(animationOptions)
  }

  @IBAction func markCorrect(sender: AnyObject) {
    answers.append(true)
    advanceQuiz()
  }

  @IBAction func markIncorrect(sender: AnyObject) {
    answers.append(false)
    advanceQuiz()
  }

  @IBAction func quit(sender: AnyObject) {
    let alert = UIAlertController(title: "Quit", message: "Are you sure?", preferredStyle: .Alert)

    let quitAction = UIAlertAction(title: "Quit", style: .Destructive, handler: { (action) -> Void in
      self.finishQuiz()
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    alert.addAction(quitAction)
    alert.addAction(cancelAction)

    self.presentViewController(alert, animated: true, completion: nil)
  }

  // MARK: - Helper methods

  private func advanceQuiz() {
    facesCountLabel.text = "Faces Viewed: \(answers.count)/\(facesToShow.count)"

    if answers.count == facesToShow.count {
      // Quiz is finished
      finishQuiz()
    }
    else {
      showCardFrontWithFace(facesToShow[answers.count])
    }
  }

  private func showCardFrontWithFace(face: Face) {
    UIView.transitionWithView(cardView, duration: 0.5, options: .TransitionCurlUp,
      animations: {
        if let image = face.imageQ {
          self.faceImageView.image = image
        }
        else {
          self.faceImageView.image = UIImage(named: "FaceViewIcon")
        }
        self.nameLabel.text = face.fullName
        self.factsTextView.text = "\n".join(face.factArray)

        self.cardFrontView.hidden = false
        self.cardBackView.hidden = true
        self.buttonsView.hidden = true
      },
      completion: nil)
  }

  private func showCardBackWithAnimationOptions(options: UIViewAnimationOptions) {
    UIView.transitionWithView(cardView, duration: 0.5, options: options,
      animations: {
        self.cardFrontView.hidden = true
        self.cardBackView.hidden = false
      },
      completion: { finished in
        self.buttonsView.hidden = false
    })
  }

  private func finishQuiz() {
    let alert = UIAlertController(title: "Quiz Finished", message: "You got \(countCorrect)/\(answers.count) correct", preferredStyle: .Alert)

    let doneAction = UIAlertAction(title: "Done", style: .Default, handler: { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
    })

    alert.addAction(doneAction)

    self.presentViewController(alert, animated: true, completion: nil)
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
