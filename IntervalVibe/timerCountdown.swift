//
//  timerCountdown.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  timerCountdown.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/13/23.
//

import SwiftUI
import SPConfetti

struct timerCountdown: View {
    
    // Create an instance of TimerSettings
    @EnvironmentObject private var timerSettings: TimerSettings
    
    // Used to call the setEqual to true once
    @State private var setEqualtrue = true
    
    
    // Set timer values to rest
    func setRestTime() {
        timerSettings.timerSecondsEdit = timerSettings.restLengthSeconds + 1
        timerSettings.timerMinutesEdit = timerSettings.restLengthMinutes
    }
    
    // Set timer values to original user input
    func setEqual(intervalSet: Bool) {
        timerSettings.timerSecondsEdit = timerSettings.intervalLengthSeconds
        timerSettings.timerMinutesEdit = timerSettings.intervalLengthMinutes
        
        if intervalSet {
            timerSettings.numOfIntervalsEdit = timerSettings.numberOfSets
        }
    }
    
    
    // Text display bools for timer
    @State private var restPeriod = false
    
    // Display the confetti!
    @State private var confettiOn = false
    
    var body: some View {

        NavigationView {
            VStack {
                let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                
                if restPeriod {
                    Text("REST")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                } else {
                    Text("GO GO GO")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(String(format: "%02i:%02i", timerSettings.timerMinutesEdit, timerSettings.timerSecondsEdit)).onReceive(timer) {
                    _ in
                    
                    // Call to start the countdowns
                    if setEqualtrue {
                        setEqual(intervalSet: true)
                        setEqualtrue = false
                    }

                    if timerSettings.timerSecondsEdit > 0 {
                        timerSettings.timerSecondsEdit -= 1
                    } else if timerSettings.timerSecondsEdit == 0 && timerSettings.timerMinutesEdit > 0 {
                        timerSettings.timerMinutesEdit -= 1
                        timerSettings.timerSecondsEdit = 59
                    } else if timerSettings.timerSecondsEdit == 0 && timerSettings.timerMinutesEdit == 0 && timerSettings.numOfIntervalsEdit > 1 {
                        
                        // Set rest period times to timer for display
                        if restPeriod == false {
                            setRestTime()
                        }
                        
                        // Toggle rest button
                        restPeriod = true
                        
                        // Rest timer begins
                        if timerSettings.timerSecondsEdit > 0 {
                            timerSettings.timerSecondsEdit -= 1
                        } else if timerSettings.timerSecondsEdit == 0 && timerSettings.timerMinutesEdit > 1 {
                            timerSettings.timerMinutesEdit -= 1
                            timerSettings.timerSecondsEdit = 59
                        } else if timerSettings.timerMinutesEdit == 0 && timerSettings.timerSecondsEdit == 0 {
                            timerSettings.numOfIntervalsEdit -= 1
                            setEqual(intervalSet: false)
                            restPeriod.toggle()
                        }
                    } else {
                        confettiOn = true
                    }
                    
                }
                .foregroundColor(.white)
                .font(.system(size: 130))
                
                Spacer()
                
                Text("SETS REMAINING: \(String(timerSettings.numOfIntervalsEdit))")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Spacer()
                Spacer()
                
                Button("End Session") {
                    confettiOn = false
                    SPConfetti.stopAnimating()
                    timerSettings.isPresentingFullScreenCover = false
                }
                .foregroundColor(.white)
                .font(.title)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(restPeriod ? .red: .green)
        }
        .overlay(
            Group{
                if confettiOn {
                    Button("Great Job!") {
                        confettiOn = false
                        SPConfetti.stopAnimating()
                        timerSettings.isPresentingFullScreenCover = false
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
        
        .onAppear {
            // Enable idle timer
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Enable idle timer
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct timerCountdown_Previews: PreviewProvider {
    static var previews: some View {
        timerCountdown()
            .environmentObject(TimerSettings())
    }
}

