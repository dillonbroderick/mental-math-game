//
//  utility.swift
//  Mental Math Game
//
//  Created by Dillon Broderick on 3/16/22.
//

import Foundation

// In the context of the game, a Pair should store

// - in its first var a string that follows the form
// 	 "X $ Y = " in which X represents the first int, Y represents
// 	 the second int, and $ represents the operation

// - in its second var a string that represents
//	 the integer answer of the problem
struct Pair<T1, T2> {
	var first: T1
	var second: T2
}
