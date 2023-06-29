//
//  intervalTimer.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  intervalTimer.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/11/23.
//

import SwiftUI

struct intervalTimer: View {
    @EnvironmentObject private var timerSettings: TimerSettings

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Length of Intervals")) {
                    Picker("Minutes", selection: $timerSettings.intervalLengthMinutes) {
                        ForEach(0..<61) {
                            Text("\($0)")
                        }
                    }
                    Picker("Seconds", selection: $timerSettings.intervalLengthSeconds) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(header: Text("Time Between Intervals")) {
                    Picker("Minutes", selection: $timerSettings.restLengthMinutes) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                    Picker("Seconds", selection: $timerSettings.restLengthSeconds) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Number of Sets")
                        Stepper(value: $timerSettings.numberOfSets, in: 1...100) {
                            Text("\(timerSettings.numberOfSets)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
                Section {
                    Button("Start Session") {
                        timerSettings.timerMinutesEdit = timerSettings.intervalLengthMinutes
                        timerSettings.timerSecondsEdit = timerSettings.intervalLengthSeconds
                        timerSettings.numOfIntervalsEdit = timerSettings.numberOfSets
                        timerSettings.isPresentingFullScreenCover = true
                    }
                    .fullScreenCover(isPresented: $timerSettings.isPresentingFullScreenCover) {
                        timerCountdown()
                    }
                }
            }
        }
        .navigationTitle("Quick Interval Setup")
        .navigationViewStyle(StackNavigationViewStyle()) // Set the navigation view style to StackNavigationViewStyle
        .onAppear {
            // Lock orientation to portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}


struct intervalTimer_Previews: PreviewProvider {
    static var previews: some View {
        intervalTimer()
            .environmentObject(TimerSettings())
    }
}



