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
                            Text("A simple way to create an interval timer. Simply select the length of the interval and how long to rest between each one. Then, select the desired amount of sets. That’s all it takes! Start your session, and you’ll be notified once you’ve completed all of your sets.\n\n")
                                .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .bottom])
                        
                        Section(header: Text("- Select / Start Invervals")
                            .font(.headline)
                            .fontWeight(.bold))
                        {
                            Text("View all of your created interval timers. After selecting a page, a drop down will appear to allow you to review the timer. This page can be rearranged by selecting the “Edit” button or by holding down the tab and dragging to a new location.\n\nIf you no longer need a timer, delete by swiping to the left or select the “Edit” button.\n\nTo begin a selected timer, simply press “Start Timer” below the summary.\n\nOnce you select “Start Timer”, you will be taken to the countdown page and the time will begin to count down. Tap anywhere on the screen to pause the timer. If you wish to cancel the timer, tap anywhere on the screen and select “End Session”.\n\n")
                                .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        // Add more sections for each step
                        
                        // Example section:
                        Section(header: Text("- Interval Builder")
                            .font(.headline)
                            .fontWeight(.bold))
                        {
                            Text("A simple way to create your own custom intervals. First, create a name to be used to identify your timer easily in the “Select / Start Intervals page”. Next, select the desired number of sets.\n\nPress the “Add New Activity” button to add countdowns to your interval timer. Simply give your activity a name and select how long you want the activity to be. Use the color slider to select the background color of the activity when playing. Press “Done” and your activity will be saved!\n\nYour activities will be displayed in a list under the “Add New Activity” button. These can be deleted by swiping to the left or rearranged by holding down and dragging them to a new location.\n\nOnce all of your activities have been added, press “Save Timer”. If you do not click “Save Timer”, you will not be able to see it in the “Select / Start Intervals” page.\n\nIf you wish to have a clean page to start a new timer, press the “Clear Page” button at the top left of the screen. Warning: if you have not saved the timer, you will not be able to recover the page. \n\nFinally, you can edit any previously existing timers by pressing the “Load Timer” button.\n\n")
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









