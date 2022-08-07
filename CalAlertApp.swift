//
//  CalAlertApp.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 5/11/21.
//

import SwiftUI

@main
struct CalAlertApp: App {
    
//   @EnvironmentObject var input : UserInput
    @StateObject var model = MyModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
               
//                NavigationView {
//                    //discoverView(location: locations.primary)
//                    //HomeScreenView(input:input)
//                    HomeScreenView(input:input)
//
//                }
//                //.environmentObject(input)
//                
//                .navigationViewStyle(StackNavigationViewStyle())
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }
//
                NavigationView {
                    //discoverView(location: locations.primary)
                    HomeScreenView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                NavigationView
                {
                    ChooseView().environmentObject(model)
                }
                
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem{
                    Image(systemName: "tram.fill")
                    Text("Select Destination")
                }
                
                NavigationView{
                    acknowledgments()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("App Details")
                }
                
            }
           // .environmentObject(input)
            
            
        }
    }
}
