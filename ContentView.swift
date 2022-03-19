//
//  ContentView.swift
//  Mental Math Game
//
//  Created by Dillon Broderick on 3/15/22.
//

import SwiftUI

extension Color {
	static let myRed = Color(red: 250 / 255, green: 68 / 255, blue: 72 / 255)
	static let myPurple = Color(red: 149 / 255, green: 96 / 255, blue: 255 / 255)
	static let myTeal = Color(red: 60 / 255, green: 197 / 255, blue: 248 / 255)
	static let myGreen = Color(red: 75 / 255, green: 203 / 255, blue: 138 / 255)
	
	static let myBlue = Color(red: 17 / 255, green: 21 / 255, blue: 32 / 255)
	static let myGrey = Color(red: 101 / 255, green: 109 / 255, blue: 136 / 255)
}

let operations = ["+", "-", "x", "/"]
let colors = [Color.myRed, Color.myPurple, Color.myTeal, Color.myGreen]

// This variable is measured in seconds and can be changed
// by the following views depending on user input
var timeCountdown = 30

let HOMESCREEN_INDICATOR = 1
let MAINGAME_INDICATOR = 2
let ENDSCREEN_INDICATOR = 3

let game = TimedMentalMathGame()

struct ContentView: View {
	
	@State var showingGame = HOMESCREEN_INDICATOR
	
	// Determine our current view
	var body: some View {
		if showingGame == HOMESCREEN_INDICATOR {
			
			HomeScreenView(viewModel: game, showingGame : $showingGame)
			
		} else if showingGame == MAINGAME_INDICATOR {
			
			MainGameView(viewModel: game, showingGame: $showingGame)
			
		}
		else {
			
			EndingScreenView(viewModel: game, showingGame: $showingGame)
			
		}
	} // Body
	
} // ContentView

// ============================================
// 				HOME SCREEN
// ============================================

struct HomeScreenView: View {
	
	var viewModel : TimedMentalMathGame
	
	@Binding var showingGame: Int
	@State var timeInput: String = ""
	
	var body: some View {
		
		ZStack {
			
			Color.myBlue.ignoresSafeArea()
			
			VStack{
				Text("Arithmetic Game")
					.fontWeight(.bold)
					.font(.largeTitle)
					.foregroundColor(.white)
					.padding(.top, 200)
				
				HStack {
					OperationCircle(text: operations[0], color: colors[0], viewModel: game)
					OperationCircle(text: operations[1], color: colors[1], viewModel: game)
					OperationCircle(text: operations[2], color: colors[2], viewModel: game)
					OperationCircle(text: operations[3], color: colors[3], viewModel: game)
				}
				
				Spacer()
				
				// Start button
				Button(
					action: {
						// Set state to main game
						// Set our timer to the user input, default is 30 seconds
						// Generate a new problem
						self.showingGame = MAINGAME_INDICATOR
						
						// If the user does not enter an integer, timeCountdown defaults to 30
						timeCountdown = Int(timeInput) ?? 30
						// If the user entered 0 or a negative integer, timeCountdown defaults to 30
						if (timeCountdown <= 0) {
							timeCountdown = 30
						}
						
						viewModel.newProblem()
					},
					label: {
						Text("Start")
							.fontWeight(.bold)
							.font(.title)
							.padding(10)
							.background(Color.myGrey)
							.cornerRadius(40)
							.foregroundColor(.white)
					}
				)
				.padding(.bottom, 200)
				
				Spacer()
				
				HStack {
					Text("Timer: ")
						.fontWeight(.bold)
						.font(.largeTitle)
						.foregroundColor(.white)
						.padding(.leading)
					
					TextField("30", text: $timeInput)
						.keyboardType(.numberPad)
						.frame(width: 40, height: 30)
						.padding(.trailing)
						.background(Color.myGrey)
						.foregroundColor(.white)
						.font(.largeTitle)
					
					Spacer()
				}
				.padding()
				
			} // VStack
			
		} // ZStack
	}
}

// ============================================
// 					DONE
// ============================================


// ============================================
// 				MAIN GAME
// ============================================

struct MainGameView: View {
	
	var viewModel : TimedMentalMathGame
	
	@FocusState private var focusedField: FocusField?
	enum FocusField: Hashable {
	  case field
	}

	@Binding var showingGame: Int
	
	@State var input: String = ""
	
	@State var timeRemaining = timeCountdown
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	
	var body: some View {
		ZStack {
			
			Color.myBlue.ignoresSafeArea()
			
			VStack {
				HStack {
					Text("Time: \(timeRemaining)")
						.fontWeight(.bold)
						.font(.largeTitle)
						.foregroundColor(.white)
						.padding(.leading)
						.onReceive(timer) { _ in
							// Decrement timer
							if timeRemaining > 0 {
								timeRemaining -= 1
							}
							// If we have reached 0, switch to the ending screen
							else {
								self.showingGame = ENDSCREEN_INDICATOR;
							}
						}
					
					Spacer()
					
					Text("Score: " + String(viewModel.getScore()))
						.fontWeight(.bold)
						.font(.largeTitle)
						.foregroundColor(.white)
						.padding(.trailing)
					
				}
				.padding(.bottom, 200) // HStack
				
				HStack {
					Text(viewModel.getCurrentProblemText())
						.fontWeight(.bold)
						.font(.largeTitle)
						.foregroundColor(.white)
						.padding(.leading)
					TextField("Answer", text: $input)
						.focused($focusedField, equals: .field)
						.task {
						  self.focusedField = .field
						}
						.keyboardType(.numberPad)
						.frame(width: 90, height: 45)
						.padding(.trailing)
						.background(Color.myGrey)
						.foregroundColor(.white)
						.font(.largeTitle)
						// Listen to changes in the text field
						.onChange(of: input) { newValue in
							// Send the current text to the viewModel
							// If our inputs matches the answer, reset the input
							if viewModel.checkAnswer(answerToCheck: input) {
								input = ""
							}
						}
				}
				
				Spacer()
				
				HStack {
					// Restart Button
					Button(
						action: {
							// Reset all necessary values
							timeRemaining = timeCountdown
							viewModel.resetScore()
							viewModel.getNewProblem()
						},
						label: {
							Text("Restart")
								.fontWeight(.bold)
								.font(.title)
								.padding(10)
								.background(Color.myRed)
								.cornerRadius(40)
								.foregroundColor(.white)
						}
					)
					.padding(10)
					
					Spacer()
				}
			} // VStack
			
		} // ZStack
	}
}

// ============================================
// 					DONE
// ============================================


// ============================================
// 				END SCREEN
// ============================================

struct EndingScreenView : View {
	
	var viewModel : TimedMentalMathGame
	
	@Binding var showingGame: Int
	
	var body: some View {
		ZStack {
			Color.myBlue.ignoresSafeArea()
			
			VStack {
				Text("Score: " + String(viewModel.getScore()))
					.fontWeight(.bold)
					.font(.largeTitle)
					.foregroundColor(.white)
					.padding(.top, 50)
					.padding(.top, 12)
				
				// Calculate answers per second and convert to a two-decimal string
				var speed : Double = Double(viewModel.getScore()) / Double(timeCountdown)
				var speedStr = String(format: "%.2f", speed)
				
				Text("Speed: " + speedStr)
					.fontWeight(.bold)
					.font(.largeTitle)
					.foregroundColor(.white)
					.padding(.bottom, 12)
				
				// Restart Button
				Button(
					action: {
						// What to perform
						self.showingGame = MAINGAME_INDICATOR
						viewModel.resetScore()
						viewModel.getNewProblem()
					},
					label: {
						Text("Restart")
							.fontWeight(.bold)
							.font(.title)
							.padding(10)
							.background(Color.myRed)
							.cornerRadius(40)
							.foregroundColor(.white)
					}
				)
				.padding(.bottom, 10)
				
				// Home Button
				Button(
					action: {
						// What to perform
						self.showingGame = HOMESCREEN_INDICATOR
						viewModel.resetScore()
						viewModel.resetNumDeactivated()
					},
					label: {
						Text("Home")
							.fontWeight(.bold)
							.font(.title)
							.padding(10)
							.background(Color.myGreen)
							.cornerRadius(40)
							.foregroundColor(.white)
					}
				)
				.padding(.bottom, 200)
			}
			
			// BEGIN--Confetti Code
			Circle()
				.fill(Color.myRed)
				.frame(width: 12, height: 12)
				.modifier(ParticlesModifier())
				.offset(x: -100, y : -50)
			
			Circle()
				.fill(Color.myBlue)
				.frame(width: 12, height: 12)
				.modifier(ParticlesModifier())
				.offset(x: -100, y : -50)
			
			Circle()
				.fill(Color.myGreen)
				.frame(width: 12, height: 12)
				.modifier(ParticlesModifier())
				.offset(x: -100, y : -50)
			
			Circle()
				.fill(Color.myTeal)
				.frame(width: 12, height: 12)
				.modifier(ParticlesModifier())
				.offset(x: 60, y : 70)
			// END--Confetti Code
			
		}
	}
}

// ============================================
// 					DONE
// ============================================

// ==========================================
// CONFETTI CODE FROM
// https://betterprogramming.pub/creating-confetti-particle-effects-using-swiftui-afda4240de6b
// ==========================================

struct FireworkParticlesGeometryEffect : GeometryEffect {
	var time : Double
	var speed = Double.random(in: 20 ... 200)
	var direction = Double.random(in: -Double.pi ...  Double.pi)
	
	var animatableData: Double {
		get { time }
		set { time = newValue }
	}
	func effectValue(size: CGSize) -> ProjectionTransform {
		let xTranslation = speed * cos(direction) * time
		let yTranslation = speed * sin(direction) * time
		let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
		return ProjectionTransform(affineTranslation)
	}
}


struct ParticlesModifier: ViewModifier {
	@State var time = 0.0
	@State var scale = 0.1
	let duration = 5.0
	
	func body(content: Content) -> some View {
		ZStack {
			ForEach(0..<80, id: \.self) { index in
				content
					.hueRotation(Angle(degrees: time * 80))
					.scaleEffect(scale)
					.modifier(FireworkParticlesGeometryEffect(time: time))
					.opacity(((duration-time) / duration))
			}
		}
		.onAppear {
			withAnimation (.easeOut(duration: duration)) {
				self.time = duration
				self.scale = 1.0
			}
		}
	}
}

// =============================================
// END OF CONFETTI CODE
// =============================================

struct OperationCircle: View {
	
	var text: String
	var color: Color
	
	var viewModel : TimedMentalMathGame
	
	@State var isActive: Bool = true

	var body: some View {
		
		ZStack {
			if isActive {
				Circle()
					.foregroundColor(color)
					.frame(width: 40, height: 40)
				
			}
			else {
				Circle()
					.foregroundColor(Color.myGrey)
					.frame(width: 40, height: 40)
			}

			Text(text)
				.fontWeight(.bold)
				.font(.title)
				.foregroundColor(.white)
			
		} // ZStack
		.onTapGesture {
			
			if isActive {
				if viewModel.getNumDeactivated() < 3 {
					isActive = false
					viewModel.incNumDeactivated()
					viewModel.toggleOperation(text)
				}
			}
			else {
				isActive = true
				viewModel.decNumDeactivated()
				viewModel.toggleOperation(text)
			}
			
		} // onTapGesture
		.padding(1)

		
	} // Body
	
} // OperationCircle








// This code simply loads the preview on the right
// This code does not affect the actual content of the app
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.previewDevice("iPhone 12")
    }
}
