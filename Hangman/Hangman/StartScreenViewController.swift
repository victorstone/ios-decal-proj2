//
//  StartScreenViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var continueGameState = GameState(inputPhrase: "for initialization purporses")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appDelegate.defaults.boolForKey("canContinue") == true)
        if appDelegate.defaults.boolForKey("canContinue") == true {
            continueGameState = GameState(inputPhrase: appDelegate.defaults.objectForKey("phrase") as! String)
            let phraseDict = appDelegate.defaults.objectForKey("phraseDict")
            let score = appDelegate.defaults.objectForKey("score") as! Int
            let incorrectGuesses = appDelegate.defaults.objectForKey("incorrectGuesses")
            let gameDone = appDelegate.defaults.objectForKey("gameDone") as! Bool
            let gameWon = appDelegate.defaults.objectForKey("gameWon") as! Bool
            let labelString = appDelegate.defaults.objectForKey("labelString") as! String
            continueGameState.score = score
            continueGameState.incorrectGuesses = incorrectGuesses as! [String]
            continueGameState.phraseDict = phraseDict as! [String : Bool]
            continueGameState.gameDone = gameDone
            continueGameState.gameWon = gameWon
            continueGameState.labelString = labelString
            continueGameState.canContinue = true
        }
        startScreenTopScore.text = String(appDelegate.defaults.integerForKey("topScore"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "continue" {
            let continueGameView = segue.destinationViewController as! InitialGameViewController
            print(continueGameState.phrase)
            print(continueGameState.canContinue)
            if continueGameState.canContinue  {
                continueGameView.gameState = continueGameState
            } else {
                let alertController = UIAlertController(title: "No Game To Continue!", message:
                    "Press New Game to start new game", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)

            }
        }
    }
    

    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func newGameAction(sender: AnyObject) {
        if continueGameState.canContinue {
            let alertController = UIAlertController(title: "Overwrite Save Game?", message:
                "You have a game to continue, start new game anyways?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: {alert in
                self.performSegueWithIdentifier("newGame", sender: self)}))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    @IBOutlet weak var startScreenNewGame: UIButton!
    @IBOutlet weak var startScreenTopScore: UILabel!
    @IBOutlet weak var startScreenContinue: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
