//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class InitialGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    @IBOutlet weak var initialScore: UILabel!
    
    @IBOutlet weak var initialBlankSpaces: UILabel!
    
    @IBOutlet weak var imageControl: UIImageView!

    @IBOutlet weak var guessTextField: UITextField!

    var gameState = GameState(inputPhrase: "duh")
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        if !gameState.canContinue{
            gameState = GameState(inputPhrase: phrase)
            initialBlankSpaces.text = gameState.labelString
            initialScore.text = "Score: " + String(gameState.score)
            gameState.canContinue = true
        } else {
            initialBlankSpaces.text = gameState.labelString
            initialScore.text = "Score: " + String(gameState.score)
            appDelegate.initialGameViewController = self
            imageControl.image = UIImage(named: "hangman" + String(gameState.incorrectGuesses.count + 1) + ".gif")
            print(gameState.incorrectGuesses.count)
            for (var i = 0; i < gameState.incorrectGuesses.count; i++) {
                if i == gameState.incorrectGuesses.count - 1 {
                    incorrectGuesses.text! += gameState.incorrectGuesses[i]
                } else {
                    incorrectGuesses.text! += gameState.incorrectGuesses[i] + ", "
                }
            }
        }
        self.guessTextField.delegate = self
    }

    @IBAction func startOverButtonAction(sender: AnyObject) {
        gameState = GameState(inputPhrase: gameState.phrase)
        initialBlankSpaces.text = gameState.labelString
        initialScore.text = "Score: " + String(gameState.score)
        gameState.canContinue = true
        imageControl.image = UIImage(named: "hangman1.gif")
        guessTextField.text = ""
        incorrectGuesses.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    let alpha : Set<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t","u"
        , "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
        "T", "U", "V", "W", "X", "Y", "Z"]
    
    func validGuess(textLabel: String) -> Bool {
        if (textLabel == "") {
            let alertController = UIAlertController(title: "No Characters!", message:
                "please enter one character", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        } else if (textLabel.characters.count > 1) {
            let alertController = UIAlertController(title: "Too Many Characters!", message:
                "please enter one character", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            if (!alpha.contains(textLabel)) {
                let alertController = UIAlertController(title: "Invalid Character!", message:
                    "please enter upper or lowercase letters", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return false
            } else if (gameState.incorrectGuesses.contains(textLabel.uppercaseString) || ((gameState.phraseDict[textLabel.uppercaseString] != nil) && (gameState.phraseDict[textLabel.uppercaseString])!)) {
                let alertController = UIAlertController(title: "Already Entered Character!", message:
                    "please enter a character you haven't already tried", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return false
            }
            return true
        }
    }


    @IBAction func pressedGuessButton(sender: AnyObject) {
        if gameState.gameDone {
            return
        }
        if (validGuess(guessTextField.text!)) {
            if (!gameState.didGuessCorrectly(guessTextField.text!)) {
                gameState.incorrectGuesses.append(guessTextField.text!.uppercaseString)
                incorrectGuesses.text = ""
                for char in gameState.incorrectGuesses {
                    if (gameState.incorrectGuesses.count == 1) {
                        incorrectGuesses.text! += char.uppercaseString
                    } else {
                        incorrectGuesses.text! += char.uppercaseString + ", "
                    }
                }
                imageControl.image = UIImage(named: "hangman" + String(1 + gameState.incorrectGuesses.count) + ".gif")
                if (gameState.incorrectGuesses.count == 6) {
                    gameState.gameDone = true
                    let alertController = UIAlertController(title: "You Lose!", message:
                        "Press Main Menu to try again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    gameState.canContinue = false
                    if (gameState.score > appDelegate.defaults.integerForKey("topScore")) {
                        appDelegate.defaults.setInteger(gameState.score, forKey: "topScore")
                    }
                }
            } else {
                if gameState.gameWon {
                    let alertController = UIAlertController(title: "You Win!", message:
                        "Press Main Menu to play again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    gameState.gameDone = true
                    gameState.canContinue = false
                    if (gameState.score > appDelegate.defaults.integerForKey("topScore")) {
                        appDelegate.defaults.setInteger(gameState.score, forKey: "topScore")
                    }
                }
            }
            initialScore.text = "Score: " + String(gameState.score)
            initialBlankSpaces.text = gameState.labelString
        }
        guessTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "backToMainMenu") {
            appDelegate.defaults.setInteger(gameState.score, forKey: "score")
            appDelegate.defaults.setObject(gameState.phraseDict, forKey: "phraseDict")
            appDelegate.defaults.setObject(gameState.phrase, forKey: "phrase")
            appDelegate.defaults.setObject(gameState.incorrectGuesses, forKey: "incorrectGuesses")
            appDelegate.defaults.setBool(gameState.gameDone, forKey: "gameDone")
            appDelegate.defaults.setBool(gameState.gameWon, forKey: "gameWon")
            appDelegate.defaults.setObject(gameState.labelString, forKey: "labelString")
            appDelegate.defaults.setBool(gameState.canContinue, forKey: "canContinue")
        }
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
