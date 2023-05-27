//
//  timerSettings.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  timerSettings.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/13/23.
//

import Foundation
import SwiftUI

class TimerSettings: ObservableObject {
    @Published var intervalLengthMinutes: Int = 0
    @Published var intervalLengthSeconds: Int = 0
    @Published var restLengthMinutes: Int = 0
    @Published var restLengthSeconds: Int = 0
    @Published var numberOfSets: Int = 1

    
    // Creating a copy of the inputs
    @Published var timerSecondsEdit = 0
    @Published var timerMinutesEdit = 0
    @Published var numOfIntervalsEdit = 0
    
    // Used to control the countdown timer page
    @Published var isPresentingFullScreenCover = false
    
    
//    // Saves the users list of interval timers
//    @Published var usersCreatedIntervals: [IntTimCall] = []
}




// Used for saving the Interval Timer Data
class DataStore: ObservableObject {
    @Published var usersCreatedIntervals: [IntTimCall] = []

    init() {
        load()
    }

    func save() {
        if let encodedData = try? JSONEncoder().encode(usersCreatedIntervals) {
            UserDefaults.standard.set(encodedData, forKey: "usersCreatedIntervals")
        }
    }

    func load() {
        if let encodedData = UserDefaults.standard.data(forKey: "usersCreatedIntervals") {
            if let decodedData = try? JSONDecoder().decode([IntTimCall].self, from: encodedData) {
                usersCreatedIntervals = decodedData
            }
        }
    }
}

