//
//  MentalMathGame.swift
//  Mental Math Game
//
//  Created by Dillon Broderick on 3/16/22.
//

import Foundation

// This allows the generation of a random number
// with exclusion of certain elements from the
// range of possible numbers
extension ClosedRange where Element: Hashable {
	func random(without excluded:[Element]) -> Element {
		let valid = Set(self).subtracting(Set(excluded))
		let random = Int(arc4random_uniform(UInt32(valid.count)))
		return Array(valid)[random]
	}
}

struct MentalMathGame {
	
	var operations = Array(repeating: true, count: 4)
	
	func generateProblem() -> Pair<String, String> {

		var numbersToExclude: [Int] = []
		
		// If an operation's corresponding index is false, we add the index
		// to numbersToExclude so a problem of that operation can't be generated
		for (index, element) in operations.enumerated() {
			if !element {
				numbersToExclude.append(index)
			}
		}
		var problemToGenerate = (0...3).random(without: numbersToExclude)
		
		switch problemToGenerate {
			case 0:
				return generateAdditionProblem(lowerBound: 2, upperBound: 100)
			case 1:
				return generateSubtractionProblem(lowerBound: 2, upperBound: 100)
			case 2:
				return generateMultiplicationProblem(lowerBound: 12, upperBound: 100)
			default:
				return generateDivisionProblem(lowerBound: 12, upperBound: 100)
		}
	}
	
	func generateAdditionProblem(lowerBound: Int, upperBound: Int) -> Pair<String, String> {
		// Intialize variables
		let firstInt = Int.random(in: lowerBound...upperBound)
		let secondInt = Int.random(in: lowerBound...upperBound)
		
		// Construct the string and answer
		return Pair<String, String>(first: String(firstInt) + " + " + String(secondInt) + " = ", second: String(firstInt + secondInt))
	}

	func generateSubtractionProblem(lowerBound: Int, upperBound: Int) -> Pair<String, String> {
		// Intialize variables
		let firstInt = Int.random(in: lowerBound...upperBound)
		let secondInt = Int.random(in: lowerBound...upperBound)
		
		// Construct the string and answer
		return Pair<String, String>(first: String(firstInt + secondInt) + " - " + String(firstInt) + " = ", second: String(secondInt))
	}

	func generateMultiplicationProblem(lowerBound: Int, upperBound: Int) -> Pair<String, String> {
		// Intialize variables
		let firstInt = Int.random(in: 2...12)
		let secondInt = Int.random(in: lowerBound...upperBound)
		
		// Construct the string and answer
		return Pair<String, String>(first: String(firstInt) + " x " + String(secondInt) + " = ", second: String(firstInt * secondInt))
	}

	func generateDivisionProblem(lowerBound: Int, upperBound: Int) -> Pair<String, String> {
		// Intialize variables
		let firstInt = Int.random(in: 2...12)
		let secondInt = Int.random(in: lowerBound...upperBound)
		
		// Construct the string and answer
		return Pair<String, String>(first: String(firstInt * secondInt) + " / " + String(firstInt) + " = ", second: String(secondInt))
	}
	
	mutating func toggle(_ operation: String) {
		if operation == "+" {
			operations[0] = !operations[0]
		}
		else if operation == "-" {
			operations[1] = !operations[1]
		}
		else if operation == "x" {
			operations[2] = !operations[2]
		}
		else {
			operations[3] = !operations[3]
		}
	}
	
	mutating func resetOperations() {
		for (index, element) in operations.enumerated() {
			operations[index] = true
		}
	}
	
}
