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


//For Wiki
struct ChooseView: View {
    enum LoadingState{
        case loading, loaded, failed
    }
    @State private var loadingState = LoadingState.loading //default state is currently loading data
    @State private var pages = [Page]() //stores an array of pages
    
    @AppStorage ("Allow Notifications") var allowNotifications: String = "Allow Notifications"
    @State var accessGranted = false
    private let locationManager = CLLocationManager()
    let stops: [Stop] = Bundle.main.decode("stops.json")
    @AppStorage("Stop Index") var selectedStopIndex: Int = 0
    @State var destConfirmation = Text("Press the button above to be notified")
    @State var stopList = []
    @StateObject private var manager = LocationManager()
    
    //@StateObject var input = UserInput()
    
    @StateObject var locationViewModel = LocationViewModel()
  @State var confirmation = "Notify when arrived at"
    
    @StateObject var input = UserInput()
   // @State var pop = false
    
    @State private var selected = 1
    @State var tracker = ""
    
    @EnvironmentObject private var model: MyModel
   // @StateObject private var model = MyModel()
    
    
    @State var destRadius = 500.0
    @State var boldText = Text("")
    
    @State var showAlert = false
    

    var body: some View {
        
       
        let annotations = [
        City(name: "\(stops[selectedStopIndex].name)", coordinate: CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude))]
    
        VStack{
            
//            TextField("Enter text here", text: $model.anytext)
//                .padding()
//                .border(Color.black, width: 1)
//                .padding()

            Form{
                Picker(selection: $selectedStopIndex, label: Text("Select Your stop")) {
            ForEach(0 ..< stops.count) {
                Text(self.stops[$0].name)
               
            
            }
           
                    
           
        }
               
              
                Button("\(confirmation) \(stops[selectedStopIndex].name)") {
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
                    model.anytext = "\(stops[selectedStopIndex].name)" //MVVM
                    model.selectedStopIndex = selectedStopIndex
                    if accessGranted == false{
                      // allowNotifications = "Please enable notifications"
                        print("no access ")
                    }
                    destConfirmation = Text("Success! You will be notified when arriving to") + Text(" \(stops[selectedStopIndex].name). ").bold() + Text("Please ensure your notifications are enabled.")
                    print("\(stops[selectedStopIndex].longitude)")
                   // confirmation = "Success! You will be notified when you arrive to"
                    let content = UNMutableNotificationContent()
                    content.title = "Arriving at \(stops[selectedStopIndex].name)"
                    content.subtitle = "This is your stop."
                    content.categoryIdentifier = "stop"
                    content.sound = UNNotificationSound.default

                   //sets geofence
                    let center = CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)

                    let region = CLCircularRegion(center: center, radius: destRadius, identifier: "Headquarters")
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
                    simpleSuccess()
                    
                    self.showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                                title: Text("Success!"),
                                message: Text("You will be notified when arriving to \(stops[selectedStopIndex].name). Please ensure your notifications are enabled.")
                            )
                            //Button("OK", role: .cancel) { }
                        }
                VStack{
                    HStack{
                        Text("0.5")
                        Slider(value: $destRadius, in: 500...2000)
                        Text("2")
                    }
                    Text("Notify when \((destRadius/1000), specifier: "%.1f") kilometers away from the destination").fixedSize(horizontal: false, vertical: true)
                }
                
                Section("Location Permissions"){
//                Text("\(destConfirmation)")
//                    destConfirmation
//                       .fixedSize(horizontal: false, vertical: true)
                switch locationViewModel.authorizationStatus {
                        case .notDetermined:
                            AnyView(RequestLocationView())
                                .environmentObject(locationViewModel)
                        case .authorizedAlways:
                            TrackingView()
                                .environmentObject(locationViewModel)
                        default:
                            Text("Unexpected status. Please change CalAlert's location permission to Always in your phone settings.")
                        }
                }
        }
            
            .navigationBarTitle("CalAlert")
            .toolbar{
                Link(destination: URL(string: "https://ryan6140.wixsite.com/hilltophistory/help-copy")!)
                {
                  Image(systemName: "person.crop.circle.badge.questionmark")
                }
                .task{
                    await fetchNearbyPlaces()
                }
                  }
 
        
        }
      
        
  
}
    //haptics
        func simpleSuccess() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    
    //wiki
    
    func fetchNearbyPlaces() async {
    let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(stops[selectedStopIndex].latitude)%7C\(stops[selectedStopIndex].longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else{
            print("Bad URL: \(urlString)")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
           // pages = items.query.pages.values.sorted {$0.title < $1.title}
            loadingState = .loaded
        } catch{
            loadingState = .failed
        }
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
        Text("Permission tracking is enabled to Always and is working as expected!")
    }
}



