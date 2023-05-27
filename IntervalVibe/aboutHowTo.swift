//
//  aboutHowTo.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  aboutHowTo.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/18/23.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    Group {
                        Section(header: Text(" - Quick Setup")
                            .font(.headline)
                            .fontWeight(.bold))
                        {
                            Text("A simple way to create an interval timer. Simply select the length of the interval and how long to rest between each one. Then, select the desired amount of sets. That’s all it takes! Start your session, and you’ll be notified once you’ve completed all of your sets.")
                                .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .bottom])
                        
                        Section(header: Text("- Select / Start Invervals")
                            .font(.headline)
                            .fontWeight(.bold))
                        {
                            Text("View all of your created interval timers. After selecting a page, a drop down will appear to allow you to review the timer. This page can be rearranged by selecting the “Edit” button or by holding down the tab and dragging to a new location.\n\nIf you no longer need a timer, delete by swiping to the left or select the “Edit” button.\n\nTo begin a selected timer, simply press “Start Timer” below the summary.")
                                .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        // Add more sections for each step
                        
                        // Example section:
                        Section(header: Text("- Interval Builder")
                            .font(.headline)
                            .fontWeight(.bold))
                        {
                            Text("A simple way to create your own custom intervals. First, create a name to be used to identify your timer easily in the “Select / Start Intervals page”. Next, select the desired number of sets.\n\nNear the bottom of the page, there is a section to enter the name of the activity. This name will be displayed during the countdown.\n\nTap on the numbers to select the desired minutes and seconds. Use the color slider to adjust what background you would like displayed during this countdown.\n\nOnce all of this is entered, simply press the “+” and the activity will be added. You know the activity has been added successfully as it will be displayed above.\n\nOnce all of your activities have been added, press “Save Timer”. If you do not click “Save Timer”, you will not be able to see it in the “Select / Start Intervals” page.")
                                .multilineTextAlignment(.leading)
                            
                            Text("And, that's it!")
                        }
                        .padding([.leading, .bottom, .trailing])
                    }
                }
                
                //Spacer()
                
                Text("Thank you for using my app! If you are interested in any of my other projects, please visit codyparkinson.com")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Tips:")
    }
}

struct HowToView_Previews: PreviewProvider {
    static var previews: some View {
        HowToView()
    }
}









