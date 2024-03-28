//
//  ContentView.swift
//  ColorChasers
//
//  Created by Jonathan Loving on 10/2/23.
//

import SwiftUI
import ConfettiSwiftUI
import AVFoundation

// Color Chasers App

struct ColoredObject
{
    var color: String
    var image: Image
    var colorSelected: Color
}

struct ContentView: View {
    @State private var button1 = "Red"
    @State private var button2 = "Blue"
    @State private var button3 = "Green"
    
    @State private var coloredObjects = [ColoredObject(color: "Red", image: Image("RedApple"), colorSelected: .red), ColoredObject(color: "Green", image: Image("GreenGrapes"), colorSelected: .green), ColoredObject(color: "Yellow", image: Image("YellowBananas"), colorSelected: .yellow), ColoredObject(color: "Orange", image: Image("Orange"), colorSelected: .orange), ColoredObject(color: "Blue", image: Image("BlueButterfly"), colorSelected: .blue), ColoredObject(color: "Purple", image: Image("PurpleGrapes"), colorSelected: .purple)]
    
    @State private var object: Int = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var score = 0
    @State private var gameCount = 0
    @State private var showingAlertGameOver = false
    @State private var lastColor: Color = .white
    @State private var finalScorePerfect = 0
    @State private var finalScoreNotPerfect = 0
    @State private var scale1 = 1.0
    @State private var scale2 = 1.0
    @State private var scale3 = 1.0
    let scaleChange = 0.20
    @State private var buzzerPlayer: AVAudioPlayer?
    
    let maxGameCount = 7
    
    var body: some View {
        ZStack
        {
            
            Image("KidsBackground2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
                .opacity(0.62)
                
            VStack
            {
                Image("ColorChaserLogo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 375, alignment: .top)
                
                Text("Score: \(score) / \(gameCount)")
                    .font(.title2)
                
                Image("WinstonTheWorm")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 375, alignment: .topTrailing)
                Spacer()
            
            
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .overlay(Circle().stroke(.black, lineWidth: 4.0))
                        .frame(width: 375, alignment: .center)
                    
                    VStack {
                        coloredObjects[object].image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        
                        Text(coloredObjects[object].color)
                            .font(.largeTitle)
                    }
                }
                .onAppear() { colorIndex() }
                Spacer()
                //Adding the 3 buttons with the colors to select
                HStack {
                    //Button 1
                    Button(action: {
                        calculateAnswer(selectButton: 0)
                        scale1 += scaleChange
                    }) {
                        Text("")
                        
                            .padding(.horizontal, 55)
                            .padding(.vertical, 25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                                
                            )
                        
                    }
                    .controlSize(.extraLarge)
                    .foregroundColor(.white)
                    .background(coloredObjects[0].colorSelected)
                    .cornerRadius(20)
                    .scaleEffect(scale1)
                    .animation(.linear(duration: 0.3), value: scale1)
                    
                    
                    //Button 2
                    Button(action: {
                        calculateAnswer(selectButton: 1)
                        scale2 += scaleChange
                    }) {
                        Text("")
                            .padding(.horizontal, 55)
                            .padding(.vertical, 25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                            )
                    }
                    .foregroundColor(.white)
                    .background(coloredObjects[1].colorSelected)
                    .cornerRadius(20)
                    .scaleEffect(scale2)
                    .animation(.linear(duration: 0.3), value: scale2)
                    
                    //Button 3
                    Button(action: {
                        calculateAnswer(selectButton: 2)
                        scale3 += scaleChange
                    }) {
                        Text("")
                            .padding(.horizontal, 55)
                            .padding(.vertical, 25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                            )
                        
                    }
                    .foregroundColor(.white)
                    .background(coloredObjects[2].colorSelected)
                    .cornerRadius(20)
                    .scaleEffect(scale3)
                    .animation(.linear(duration: 0.3), value: scale3
                    )
                }
                .confettiCannon(counter: $finalScoreNotPerfect, num: 100, radius: 0.0)
                .confettiCannon(counter: $finalScorePerfect, num: 100, radius: 500.0)
                Spacer()
                Spacer()
                .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { colorIndex()
                        lastColor = coloredObjects[object].colorSelected
                        scale1 = 1
                        scale2 = 1
                        scale3 = 1
                    }
                }
                .alert("Game Over.\nScore \(score)/\(gameCount)", isPresented: $showingAlertGameOver) {
                    Button("New Game", role: .cancel) {
                        gameCount = 0
                        score = 0
                        colorIndex()
                        lastColor = .white
                        scale1 = 1
                        scale2 = 1
                        scale3 = 1
                    }
                }
            }
        }
    }
    
    func colorIndex()
    {
        
        object = Int.random(in: 0..<3)
        coloredObjects.shuffle()
        
        while coloredObjects[object].colorSelected == lastColor
        {
            object = Int.random(in: 0..<3)
        }
    }
    func calculateAnswer(selectButton: Int)
    {
        gameCount += 1
        
        if object == selectButton && gameCount < maxGameCount
        {
            score += 1
            alertMessage = "Good Job!!!"
            playCorrectAnswer()
            showingAlert = true
        }
        else if object != selectButton && gameCount < maxGameCount
        {
            alertMessage = "Try again!!!"
            playWrongAnswer()
            showingAlert = true
        }
        else if object == selectButton && gameCount == maxGameCount
        {
            score += 1
            if score == maxGameCount
            {
                playHighScoreWin()
                finalScorePerfect += 1
                showingAlertGameOver = true
            }
            else
            {
                playLowScoreWin()
                finalScoreNotPerfect += 1
                showingAlertGameOver = true
            }
        }
        else
        {
            playLowScoreWin()
            showingAlertGameOver = true
            finalScoreNotPerfect += 1
        }
    }
    
    func playCorrectAnswer() {
        if let buzzerSound = NSDataAsset(name: "CorrectAnswer") {
            do {
                buzzerPlayer = try AVAudioPlayer(data: buzzerSound.data)
                buzzerPlayer?.play()
            } catch {
                print("Error playing buzzer sound: \(error)")
            }
        }
    }
    func playWrongAnswer() {
        if let buzzerSound = NSDataAsset(name: "WrongAnswer") {
            do {
                buzzerPlayer = try AVAudioPlayer(data: buzzerSound.data)
                buzzerPlayer?.volume = 0.5
                buzzerPlayer?.play()
            } catch {
                print("Error playing buzzer sound: \(error)")
            }
        }
    }
    
    func playHighScoreWin() {
        if let buzzerSound = NSDataAsset(name: "HighScoreWin") {
            do {
                buzzerPlayer = try AVAudioPlayer(data: buzzerSound.data)
                buzzerPlayer?.play()
            } catch {
                print("Error playing buzzer sound: \(error)")
            }
        }
    }
    
    func playLowScoreWin() {
        if let buzzerSound = NSDataAsset(name: "LowScoreWin") {
            do {
                buzzerPlayer = try AVAudioPlayer(data: buzzerSound.data)
                buzzerPlayer?.play()
            } catch {
                print("Error playing buzzer sound: \(error)")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
