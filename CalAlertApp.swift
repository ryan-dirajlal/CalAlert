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
                    Text("Select Destination")
                }
                
//                NavigationView {
//                    //discoverView(location: locations.primary)
//                    help()
//                }
//                .tabItem {
//                    Image(systemName: "person.crop.circle.badge.questionmark")
//                    Text("Help")
//                }
                
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
