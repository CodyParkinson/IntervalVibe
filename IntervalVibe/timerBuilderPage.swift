//
//  timerBuilderPage.swift
//  IntervalVibe
//
//  Created by Cody Parkinson on 5/27/23.
//
// Originally:
//  timerBuilderPage.swift
//  Adequate Timer 2
//
//  Created by Cody Parkinson on 5/13/23.
//

import SwiftUI

struct TimerBuilderPage: View {
    @EnvironmentObject private var TimerSettings: TimerSettings
    @EnvironmentObject private var DataStore: DataStore
    
    // Alert user that there is no title/activities when saving
    @State private var noTitle = false
    @State private var noActivities = false
    
    // Allow user to load previous list
    @State private var isLoadTimerSheetPresented = false
    @State private var refreshFlag = false
    @State private var checkToOverride = true
    
    // Popup variable
    @State private var isShowingPopup = false
    
    // Add new item page variable
    @State private var isAddingItemSheetPresented = false
    
    // Add clear page variable
    @State private var isClearPageAlertPresented = false
    
    // Is title already in use
    @State private var isTitleAlreadyExistsAlertPresented = false
    @State private var shouldSaveItems = false
    
    
    @State private var itemName: String = ""
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    @State private var title: String = TimerData.shared.getTitle()
    @State private var numberOfSets: Int = TimerData.shared.getSets()
    @State private var items: [TimerItem] = TimerData.shared.getItems()
    
    @State private var hue: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Timer Name: ")
                    .padding([.top, .leading, .bottom])
                    .font(.headline)
                
                TextField("Title", text: $title)
                    .padding([.top, .bottom, .trailing])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.white)
            }
            .border(.gray, width:1)
            
            HStack {
                Text("Number of Sets: ")
                    .font(.headline)
                    .padding()
                
                Picker("# of Sets", selection: $numberOfSets) {
                    ForEach(1...99, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 150)
                .padding(.vertical)
                .padding(.leading, -40)
                
                Spacer()
            }
            .border(.gray, width:1)
            
            
            VStack {
                VStack(alignment: .leading) {
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            isAddingItemSheetPresented = true
                        }) {
                            HStack {
                                Text("Add New Activity")
                                    .font(.headline)
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.top)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $isAddingItemSheetPresented) {
                    VStack {
                        Text("Add Activity")
                            .font(.title)
                            .padding()
                        
                        TextField("Enter Activity Name", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Picker("Minutes", selection: $selectedMinutes) {
                                ForEach(0..<60) { minute in
                                    Text(formattedTime(time: minute))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 150)
                            //.clipped()
                            
                            Text(" : ")
                                .font(.largeTitle)
                            
                            Picker("Seconds", selection: $selectedSeconds) {
                                ForEach(0..<60) { second in
                                    Text(formattedTime(time: second))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 150)
                            //.clipped()
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(Color(hue: hue, saturation: 0.8, brightness: 0.83))
                                .frame(height: 10)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            
                            Slider(value: $hue, in: 0...1, step: 0.01)
                                .padding(.horizontal)
                        }
                        .padding()
                        
                        
                        Button(action: {
                            isAddingItemSheetPresented = false
                            addNewItem()
                            saveItemsInScope()
                        }) {
                            Text("Done")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.blue)
                                        .opacity(0.8)
                                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                                )
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .disabled(itemName.isEmpty)
                        
                    }
                }
                
                
                List {
                    ForEach(items) { item in
                        Text("\(item.name): \(item.minutes) Min \(item.seconds) Sec")
                            .foregroundColor(.white)
                            .listRowBackground(Color(hue: item.hue, saturation: 0.8, brightness: 0.83))
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(action: {
                                    deleteItem(item)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                    .onDelete { indexSet in
                        deleteItems(at: indexSet)
                    }
                    .onMove { indices, newOffset in
                        items.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    
                }
                .listStyle(.plain)
                .background(Color.clear) // Set the list background color to clear
                .padding(.horizontal)
            }
            .border(.gray, width:1)
                
            Spacer()
            

            
            VStack {
                HStack {
                    Button(action: {
                        isLoadTimerSheetPresented = true
                        refreshView()
                    }) {
                        Text("Load Timer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    
                    Button(action: {
                        checkDupNames()
                    }) {
                        Text("Save Timer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline) // Empty navigation bar title
            .navigationBarHidden(false) // Hide the navigation bar
            
            
            /*
             **************************************************************************************
             This code works with the multiple VStacks for the alerts.
             I do not know if this is the best way to do this, but it works
             If you put the alerts all on the same view, then only the last one will appear
             In testing the code works, so don't touch it!
             */
            
            // Save Alert
            VStack{}
            .alert(isPresented: $isShowingPopup) {
                Alert(title: Text("Saved!"), dismissButton: .default(Text("OK")))
            }
            .onChange(of: isShowingPopup) { newValue in
                if !newValue {
                    // Alert is dismissed, reset the variable to false
                    isShowingPopup = false
                }
            }
            
            // No title alert
            VStack{}
            .alert(isPresented: $noTitle) {
                Alert(title: Text("Please include a name for the timer!"), dismissButton: .default(Text("OK")))
            }
            
            // No activities alert
            VStack{}
            .alert(isPresented: $noActivities) {
                Alert(title: Text("Please include some activities!"), dismissButton: .default(Text("OK")))
            }
            
            VStack {}
            // Unique title alert
            .alert(isPresented: $isTitleAlreadyExistsAlertPresented) {
                Alert(
                    title: Text("Timer Already Exists"),
                    message: Text("Override previous save?"),
                    primaryButton: .destructive(Text("Save"), action: {
                        saveItems()
                        shouldSaveItems = true
                    }),
                    secondaryButton: .cancel()
                )
            }
                
            VStack {}
            // Clear Page Alert
            .alert(isPresented: $isClearPageAlertPresented) {
                Alert(
                    title: Text("Clear Page"),
                    message: Text("Are you sure you want to clear the page?"),
                    primaryButton: .destructive(Text("Clear"), action: {
                        clearPage()
                    }),
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isClearPageAlertPresented = true
                    }) {
                        Text("Clear Page")
                            .foregroundColor(.blue)
                    }
                }
            }
            /*
             **************************************************************************************
             */
            
            
        }
        .sheet(isPresented: $isLoadTimerSheetPresented, onDismiss: {refreshView()}) {
            LoadTimerSheet()
        }
        
        // reload data upon reentry of the page
        .onAppear {
            loadTimerData()
        }
        
        // Update page after user loads in previous timer
        .onChange(of: refreshFlag) { _ in
            title = TimerData.shared.getTitle()
            numberOfSets = TimerData.shared.getSets()
            items = TimerData.shared.getItems()
        }
    }
    
    // Add clearPage function
    private func clearPage() {
        title = ""
        numberOfSets = 1
        items.removeAll()
        
        saveItemsInScope()
    }
    
    private func addNewItem() {
        let newItem = TimerItem(name: itemName, minutes: selectedMinutes, seconds: selectedSeconds, hue: hue)
        items.append(newItem)
        
        // Reset input fields
        itemName = ""
        selectedMinutes = 0
        selectedSeconds = 0
        hue = 0.0
    }
    
    private func deleteItem(_ item: TimerItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    
    
    private func saveItems() {
        let existingTitles = DataStore.usersCreatedIntervals.map { $0.title }

        if let existingIndex = existingTitles.firstIndex(of: title) {
            // Item with the same title exists, update it
            var existingItem = DataStore.usersCreatedIntervals[existingIndex]
            existingItem.numOfSets = numberOfSets
            existingItem.timerItems = items
            DataStore.usersCreatedIntervals[existingIndex] = existingItem
            shouldSaveItems = true
        } else {
            // Item with the same title doesn't exist, append a new one
            DataStore.usersCreatedIntervals.append(IntTimCall(title: title, numOfSets: numberOfSets, timerItems: items))
            isShowingPopup = true
        }

        // Save other data
        TimerData.shared.saveItems(items)
        TimerData.shared.saveTitle(title)
        TimerData.shared.saveSets(numberOfSets)
    }


    
    
    // Toggle check for duplicate names
    private func checkDupNames() {
        let existingTitles = DataStore.usersCreatedIntervals.map { $0.title }
        
        if existingTitles.contains(title) {
            // Display an alert for duplicate title
            isTitleAlreadyExistsAlertPresented = true
        } else if title == "" {
            noTitle = true
        } else if items == [] {
            noActivities = true
        } else {
            saveItems()
        }
    }
    
    
    
    
    // Save only the values within the builder, but don't save to the intervalTimerListView
    private func saveItemsInScope() {
        TimerData.shared.saveItems(items)
        TimerData.shared.saveTitle(title)
        TimerData.shared.saveSets(numberOfSets)
    }
    
    
    
    private func formattedTime(time: Int) -> String {
        return String(format: "%02d", time)
    }
    
    // Load data when reentering the page
    private func loadTimerData() {
        title = TimerData.shared.getTitle()
        numberOfSets = TimerData.shared.getSets()
        items = TimerData.shared.getItems()
    }
    
    // Function to trigger the view refresh
    private func refreshView() {
        refreshFlag.toggle()
    }
}



struct TimerItem: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let minutes: Int
    let seconds: Int
    let hue: Double
}

struct IntTimCall: Identifiable, Codable {
    var id = UUID()
    let title: String
    var numOfSets: Int
    var timerItems: [TimerItem]
}





struct LoadTimerSheet: View {
    @EnvironmentObject private var dataStore: DataStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(dataStore.usersCreatedIntervals) { interval in
                Button(action: {
                    loadTimer(interval)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(interval.title)
                }
            }
            .navigationTitle("Load Timer")
        }
    }
    
    private func loadTimer(_ interval: IntTimCall) {
        TimerData.shared.saveTitle(interval.title)
        TimerData.shared.saveSets(interval.numOfSets)
        TimerData.shared.saveItems(interval.timerItems)
    }
}







struct TimerBuilderPage_Previews: PreviewProvider {
    static var previews: some View {
        TimerBuilderPage()
            .environmentObject(TimerSettings())
            .environmentObject(DataStore())
    }
}


