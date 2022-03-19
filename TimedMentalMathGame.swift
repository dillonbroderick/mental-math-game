//
//  TimedMentalMathGame.swift
//  Mental Math Game
//
//  Created by Dillon Broderick on 3/16/22.
//

import SwiftUI

class TimedMentalMathGame {
	
	private(set) var model: MentalMathGame = MentalMathGame();
	
	var currentProblem : Pair<String, String>
	
	var score : Int
	
	var numDeactivated: Int
	
	init () {
		score = 0
		numDeactivated = 0
		// This line below is redundant, but will not compile without because
		// every member variable must be initialized
		currentProblem = model.generateProblem()
	}
	
	func newProblem() {
		currentProblem = model.generateProblem()
	}
	
	func getCurrentProblemText() -> String {
		return currentProblem.first
	}
	
	func getCurrentProblemAnswer() -> String {
		return currentProblem.second
	}
	
	func getScore() -> Int {
		score
	}
	
	func incScore() {
		score += 1
	}
	
	func resetScore() {
		score = 0
	}
	
	func getNumDeactivated() -> Int {
		numDeactivated
	}
	
	func incNumDeactivated() {
		numDeactivated += 1
	}
	
	func decNumDeactivated() {
		numDeactivated -= 1
	}
	
	func resetNumDeactivated() {
		numDeactivated = 0
		model.resetOperations()
	}
	
	func getNewProblem() {
		currentProblem = model.generateProblem()
	}
	
	func toggleOperation(_ operation : String) {
		model.toggle(operation)
	}
	
	func checkAnswer(answerToCheck: String) -> Bool {
		if answerToCheck == getCurrentProblemAnswer() {
			currentProblem = model.generateProblem()
			incScore()
			return true
		}
		return false
	}
}
