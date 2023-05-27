//
//  intervalTimerListView.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  intervalTimerListView.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/17/23.
//

import SwiftUI
import SPConfetti
import AVFoundation
import UIKit

struct IntervalTimerListView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
            List {
                ForEach(dataStore.usersCreatedIntervals) { intTimCall in
                    DisclosureGroup(
                        content: {
                            VStack {
                                Text("# of Sets: \(intTimCall.numOfSets)")
                                ForEach(intTimCall.timerItems) { timerItems in
                                    Text("\(timerItems.name): \(formattedTime(minutes: timerItems.minutes, seconds: timerItems.seconds))")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hue: timerItems.hue, saturation: 0.8, brightness: 0.83))
                                }
                                
                                
                                NavigationLink(destination: IntervalTimerDetailView(intTimCall: intTimCall)) {
                                    Text("Start Timer")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.blue)
                                                    .opacity(0.8)
                                                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                                            )
                                }
                                .padding(.top, 10)
                            }
                        },
                        label: {
                            Text(intTimCall.title)
                        }
                    )
                }
                .onDelete { indexSet in
                    dataStore.usersCreatedIntervals.remove(atOffsets: indexSet)
                    dataStore.save() // Save after deletion
                }
                .onMove { sourceIndices, destinationIndex in
                    dataStore.usersCreatedIntervals.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
                    dataStore.save() // Save after reordering
                }
            }
            .navigationBarItems(trailing: EditButton())
            .onDisappear {
                dataStore.save() // Save when the view disappears
            }
            .navigationTitle("Select / Start")
    }
    
    private func formattedTime(minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
}





struct IntervalTimerDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.sizeCategory) var sizeCategory

    // Audio Player
    @State private var beepPlayer: AVAudioPlayer!
    
    // Display the confetti!
    @State private var confettiOn = false
    
    let intTimCall: IntTimCall
    @State private var currentSet: Int = 0
    @State private var currentTimerIndex: Int = 0
    @State private var currentMinutes: Int = 0
    @State private var currentSeconds: Int = 0
    @State private var isTimerRunning: Bool = false
    @State private var timer: Timer?
    
    // Calculate the next value
    var nextTimer: String {
            let nextIndex = currentTimerIndex + 1
            if nextIndex < intTimCall.timerItems.count {
                return intTimCall.timerItems[nextIndex].name
            } else if currentSet == intTimCall.numOfSets {
                return "Last One!"
            } else if nextIndex == intTimCall.timerItems.count && currentSet != intTimCall.numOfSets - 1 {
                return intTimCall.timerItems[0].name
            } else {
                return "Last One!"
            }
        }
    
    // Calculate the next color
    var nextColor: Double {
            let nextColor = currentTimerIndex + 1
            if nextColor < intTimCall.timerItems.count {
                return intTimCall.timerItems[nextColor].hue
            } else if currentSet == intTimCall.numOfSets {
                return 0.3
            } else if nextColor == intTimCall.timerItems.count && currentSet != intTimCall.numOfSets - 1 {
                return intTimCall.timerItems[0].hue
            } else {
                return 0.3
            }
        }
    

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    
                    Spacer()
                    
                    Text(intTimCall.timerItems[currentTimerIndex].name)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
            
                    Spacer()
                    
                    
                    Text(formattedTime(minutes: currentMinutes, seconds: currentSeconds))
                        .foregroundColor(.white)
                        .font(.system(size: getSizeForFont()))
                        .font(Font.system(.title, design: .monospaced))

                        
                    
                    Spacer()
                        
                    
                    Text("Sets Remaining: \(intTimCall.numOfSets - currentSet)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Text("Next: \(nextTimer)")
                        .foregroundColor(.white)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing])
                        .background(Color(hue: nextColor, saturation: 0.8, brightness: 0.83))
                        .cornerRadius(10)
                        

                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        confettiOn = false
                        SPConfetti.stopAnimating()
                    }) {
                        Text("End Session")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                        
                }
                .onAppear {
                    // Disable idle timer
                    UIApplication.shared.isIdleTimerDisabled = true
                    
                    resetTimer()
                    startTimer()
                }
                .onDisappear {
                    // Enable idle timer
                    UIApplication.shared.isIdleTimerDisabled = false
                    
                    stopTimer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hue: intTimCall.timerItems[currentTimerIndex].hue, saturation: 0.8, brightness: 0.83))
    
        }
        .navigationBarBackButtonHidden(true)
        .overlay(
            Group{
                if confettiOn {
                    Button("Great Job!") {
                        presentationMode.wrappedValue.dismiss()
                        confettiOn = false
                        SPConfetti.stopAnimating()
                    }
                        .multilineTextAlignment(.center)
                        .background(.white)
                        .font(.system(size: 120))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }
            }
        )
        .confetti(isPresented: $confettiOn,
                  animation: .fullWidthToDown,
                  particles: [.triangle, .arc],
                  duration: 1000.0)
    }


    private func startTimer() {
        guard !isTimerRunning else { return }

        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            if self.currentSeconds > 0 {
                self.currentSeconds -= 1
            } else if self.currentMinutes > 0 {
                self.currentMinutes -= 1
                self.currentSeconds = 59
            } else {
                if self.currentTimerIndex < self.intTimCall.timerItems.count - 1 {
                    self.currentTimerIndex += 1
                    self.resetTimer() // Reset the timer for the next item
                    //self.startTimer() // Start the timer for the next item
                } else {
                    self.currentSet += 1
                    if self.currentSet < self.intTimCall.numOfSets {
                        self.currentTimerIndex = 0
                        self.resetTimer()
                        self.startTimer()
                    } else {
                        self.confettiOn = true
                        timer.invalidate()
                        self.isTimerRunning = false
                    }
                }
            }
            
            if self.currentMinutes == 0 && self.currentSeconds <= 3 {
                self.playBeepSound(for: self.currentSeconds)
            }
        }
    }

    
    
    private func playBeepSound(for seconds: Int) {
        var soundName = ""
        switch seconds {
        case 3:
            soundName = "BEEP1"
        case 2:
            soundName = "BEEP2"
        case 1:
            soundName = "BEEP3"
        case 0:
            soundName = "BEEP4"
        default:
            return
        }

        guard let beepURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Failed to locate the \(soundName) sound file")
            return
        }

        do {
            self.beepPlayer = try AVAudioPlayer(contentsOf: beepURL)
            beepPlayer?.play()
        } catch {
            print("Failed to play the \(soundName) sound: \(error)")
        }
    }
    
    

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }

    private func resetTimer() {
        currentMinutes = intTimCall.timerItems[currentTimerIndex].minutes
        currentSeconds = intTimCall.timerItems[currentTimerIndex].seconds
    }

    private func formattedTime(minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getSizeForFont() -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return 180
        } else {
            return 130
        }
    }
    
}












struct I_Previews: PreviewProvider {
    static var previews: some View {
        IntervalTimerListView()
            .environmentObject(DataStore())
    }
}

