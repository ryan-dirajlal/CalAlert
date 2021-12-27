//
//  ContentView.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 5/11/21.
//

import SwiftUI
import UserNotifications
import CoreLocation
import MapKit
struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class UserInput: ObservableObject {
    @Published var destinationStop = ""
}


struct ContentView: View {
    
    @AppStorage ("Allow Notifications") var allowNotifications: String = "Allow Notifications"
    @State var accessGranted = false
    private let locationManager = CLLocationManager()
    let stops: [Stop] = Bundle.main.decode("stops.json")
    @AppStorage("Stop Index") var selectedStopIndex: Int = 0
    @State var stopList = []
    @StateObject private var manager = LocationManager()
    
    //@StateObject var input = UserInput()
    
    @StateObject var locationViewModel = LocationViewModel()
  @State var confirmation = "Please click the button above to be notified at your destination"
    
    @StateObject var input = UserInput()
   // @State var pop = false
    
    @State private var selected = 1
    var body: some View {
        
       
        let annotations = [
        City(name: "\(stops[selectedStopIndex].name)", coordinate: CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude))]
    
        VStack{
            
           
            Form{
                Picker(selection: $selectedStopIndex, label: Text("Select Your stop")) {
            ForEach(0 ..< stops.count) {
                Text(self.stops[$0].name)
            
            }
           
        }
              
                Button("Notify when arrived at \(stops[selectedStopIndex].name)") {
                    if accessGranted == false{
                       allowNotifications = "Please enable notifications"
                        print("no access ")
                    }
                    print("\(stops[selectedStopIndex].longitude)")
                    confirmation = "Success! You will be notified when you arrive to \(stops[selectedStopIndex].name)"
                    let content = UNMutableNotificationContent()
                    content.title = "Arriving at \(stops[selectedStopIndex].name)"
                    content.subtitle = "This is your stop."
                    content.categoryIdentifier = "stop"
                    content.sound = UNNotificationSound.default

                   //sets geofence
                    let center = CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)

                    let region = CLCircularRegion(center: center, radius: 500, identifier: "Headquarters")
                    region.notifyOnEntry = true //notify user when they enter
                    region.notifyOnExit = false //do not notify when they exit

                    //when user enters, trigger notification
                    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)

                   //  choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                   //print("waiting to enter location")

                    // add our notification request
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().add(request)
                    
                    
                    //for other view:
                    self.input.destinationStop = stops[selectedStopIndex].name
                   // pop.toggle()
                }
               // buttonAlert()
               Text("\(confirmation)")
        }
            
            .navigationBarTitle("CalAlert")
            .toolbar{
                Link(destination: URL(string: "https://ryan6140.wixsite.com/hilltophistory/help-copy")!)
                {
                  Image(systemName: "person.crop.circle.badge.questionmark")
                }
                          
                  }
            .frame( maxWidth: 500, maxHeight: 149)
            
            
        
            
//            NavigationLink(destination: HomeScreenView(destinationStop: self.$input.destinationStop)) {
//                                Text("Next View")
//                            }
  
         
           
           ZStack
           {
            Color(red: 1, green: 0.55, blue: 0.55)
           
            VStack{
                Image(systemName: "tram.fill")
                Text("Your stop: ").bold()
                Text("\(stops[selectedStopIndex].name)").bold().font(.largeTitle)//.font(.system(size: 20))
//                Text("Latitude: ").bold() + Text("\(stops[selectedStopIndex].latitude)")
//                Text("Longitude: ").bold() + Text("\(stops[selectedStopIndex].longitude)")
        switch locationViewModel.authorizationStatus {
                case .notDetermined:
                    AnyView(RequestLocationView())
                        .environmentObject(locationViewModel)
                case .restricted:
                    ErrorView(errorText: "Location use is restricted.")
                case .denied:
                    ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
                case .authorizedWhenInUse:
                    ErrorView(errorText: "Location is only enabled while app is in use. Please enable to Always Allow in your phone settings.").fixedSize(horizontal: false, vertical: true)
            
                case .authorizedAlways:
                    TrackingView()
                        .environmentObject(locationViewModel)
                default:
                    Text("Unexpected status")
                }
            
        

            Button(allowNotifications) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                        allowNotifications = "Notifications enabled!"
                        accessGranted = true
                    } else if let error = error {
                        print(error.localizedDescription)
                        allowNotifications = "Please enable notifications"
                    }
//                    else if accessGranted == false{
//                       allowNotifications = "Please enable notifications"
//
//
//                    }
                }
            }
                
           
            }
            
           }
           .frame(maxHeight: 200)
            
            
      
           
            
            VStack{
              //  Spacer()
            Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: annotations)
            {
                MapPin(coordinate: $0.coordinate)
            }
            }
            
 
        
        }
        
        
//        if pop == true{
//            HomeScreenView(input: input)
//        }
        HomeScreenView(input: input)
}
}

    struct RequestLocationView: View {
        @EnvironmentObject var locationViewModel: LocationViewModel
        
        var body: some View {
            VStack {
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Button(action: {
                    locationViewModel.requestPermission()
                }, label: {
                    Label("Allow tracking to begin", systemImage: "location")
                })
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                Text("We need your permission to alert you based on your location.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
//        Text("Permission Tracking Enabled")
        Text("")
    }
}



