////
////  WorldView.swift
////  CalAlert
////
////  Created by Ryan Dirajlal on 5/22/21.
////
//
//import SwiftUI
//import UserNotifications
//import CoreLocation
//import MapKit
//
//struct buttonAlert: View {
//
//    @AppStorage ("Allow Notifications") var allowNotifications: String = "Allow Notifications"
//    @State var accessGranted = false
//    private let locationManager = CLLocationManager()
//    let stops: [Stop] = Bundle.main.decode("stops.json")
//    @AppStorage("Stop Index") var selectedStopIndex: Int = 0
//    @State var stopList = []
//    @StateObject private var manager = LocationManager()
//
//    @StateObject var locationViewModel = LocationViewModel()
//  @State var confirmation = "Please click the button above to be notified at your destination"
//
//
//
//    var body: some View {
//Button("Notify when arrived at \(stops[selectedStopIndex].name)") {
//    if accessGranted == false{
//        print("no access")
//        confirmation = "Success! You will be notified when you arrive to \(stops[selectedStopIndex].name)"
//    }
//
//
//    let content = UNMutableNotificationContent()
//    content.title = "Arriving at \(stops[selectedStopIndex].name)"
//    content.subtitle = "This is your stop."
//    content.sound = UNNotificationSound.default
//
//   //sets geofence
//    let center = CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)
//
//    let region = CLCircularRegion(center: center, radius: 500, identifier: "Headquarters")
//    region.notifyOnEntry = true //notify user when they enter
//    region.notifyOnExit = false //do not notify when they exit
//
//    //when user enters, trigger notification
//    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//
//   //  choose a random identifier
//    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//   print("waiting to enter location")
//
//    // add our notification request
//    UNUserNotificationCenter.current().add(request)
//
//}
//        Text("\(confirmation)")
//    }
//}
