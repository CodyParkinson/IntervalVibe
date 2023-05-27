//
//  ContentView.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  Adequate Timer 2
//  Created by Cody Parkinson on 5/17/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerSettings = TimerSettings()
    let dataStore = DataStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: intervalTimer()) {
                    Text("Quick Setup")
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: IntervalTimerListView()) {
                    Text("Select / Start Intervals")
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: TimerBuilderPage()) {
                    Text("Interval Builder")
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                NavigationLink(destination: HowToView()) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                
            }
            .padding()
            .navigationBarTitle("IntervalVibe+")
        }
        .environmentObject(timerSettings)
        .environmentObject(dataStore)
        .accentColor(.white)
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

