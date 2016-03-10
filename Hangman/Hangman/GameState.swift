//
//  GameState.swift
//  Hangman
//
//  Created by Victor Stone on 3/9/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import Foundation

class GameState {
    var score : Int
    var phraseDict = [String: Bool]()
    var phrase : String
    var incorrectGuesses = [String]()
    var gameDone : Bool
    var gameWon : Bool
    var labelString = ""
    var canContinue : Bool
    
    init(inputPhrase: String) {
        phrase = inputPhrase
        for char in inputPhrase.characters {
            if char != " " {
                labelString += "_ "
                phraseDict[String(char)] = false
            } else {
                labelString += "  "
            }
        }
        score = 100
        gameDone = false
        gameWon = false
        canContinue = false
        print(phraseDict.count)
        print(phrase.characters)
    }
    
    func didGuessCorrectly(character: String) -> Bool {
        print(phraseDict.count)
        let stringCharacter = String(character).uppercaseString
        let guessState = phraseDict[stringCharacter]
        if guessState == nil {
            score -= 5
            return false
        }
        phraseDict[stringCharacter] = true
        labelString = ""
        gameWon = true
        for character in phrase.characters {
            //creating new label logic
            let char = String(character)
            if char != " " {
                if phraseDict[char]! {
                    labelString += char + " "
                } else {
                    labelString += "_ "
                    gameWon = false
                }
            } else {
                labelString += "  "
            }            
        }
        return true
    }
}