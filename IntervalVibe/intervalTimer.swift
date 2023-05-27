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
    
    @EnvironmentObject private var TimerSettings: TimerSettings
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Minutes", selection: $TimerSettings.intervalLengthMinutes) {
                        ForEach(0..<61) {
                            Text("\($0)")
                        }
                    }
                    Picker("Seconds", selection: $TimerSettings.intervalLengthSeconds) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                } header: {
                    Text("Length of Intervals")
                }
                
                Section {
                    Picker("Minutes", selection: $TimerSettings.restLengthMinutes) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                    Picker("Seconds", selection: $TimerSettings.restLengthSeconds) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                } header: {
                    Text("Time Between Intervals")
                }
                
                Section {
                    HStack {
                        Text("Number of Sets")
                        Stepper(value: $TimerSettings.numberOfSets, in: 1...100) {
                            Text("\(TimerSettings.numberOfSets)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
                Section {
                    Button("Start Session") {
                        TimerSettings.timerMinutesEdit = TimerSettings.intervalLengthMinutes
                        TimerSettings.timerSecondsEdit = TimerSettings.intervalLengthSeconds
                        TimerSettings.numOfIntervalsEdit = TimerSettings.numberOfSets
                        TimerSettings.isPresentingFullScreenCover = true
                    }
                    .fullScreenCover(isPresented: $TimerSettings.isPresentingFullScreenCover) {
                        timerCountdown()
                    }
                }
            }
        }
        .navigationTitle("Quick Interval Setup")
    }
}

struct intervalTimer_Previews: PreviewProvider {
    static var previews: some View {
        intervalTimer()
            .environmentObject(TimerSettings())
    }
}



