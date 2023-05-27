//
//  TimerData.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  TimerData.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/14/23.
//

import Foundation

class TimerData: ObservableObject {
    static let shared = TimerData()
    
    @Published var items: [TimerItem] = []
    @Published var title: String = ""
    @Published var numberOfSets: Int = 1
    
    private let itemsKey = "timerItems"
    private let titleKey = "timerTitle"
    private let numberOfSetsKey = "timerNumberOfSets"
    
    
    init() {
        loadItems()
        loadTitle()
        loadNumberOfSets()
    }
    
    
    func saveItems(_ items: [TimerItem]) {
        self.items = items
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
    }
    
    func getItems() -> [TimerItem] {
        return items
    }
    
    
    func saveTitle(_ title: String) {
        self.title = title
        UserDefaults.standard.set(title, forKey: titleKey)
    }
    
    func getTitle() -> String {
        return title
    }
    
    
    func saveSets(_ numberOfSets: Int) {
        self.numberOfSets = numberOfSets
        UserDefaults.standard.set(numberOfSets, forKey: numberOfSetsKey)
    }
    
    func getSets() -> Int {
        return numberOfSets
    }
    
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: itemsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([TimerItem].self, from: data) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    private func loadTitle() {
        if let savedTitle = UserDefaults.standard.string(forKey: titleKey) {
            self.title = savedTitle
        } else {
            self.title = ""
        }
    }
    
    private func loadNumberOfSets() {
        if let savedNumberOfSets = UserDefaults.standard.object(forKey: numberOfSetsKey) as? Int {
            self.numberOfSets = savedNumberOfSets
        } else {
            self.numberOfSets = 1
        }
    }
    
}


