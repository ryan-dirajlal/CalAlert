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
import CoreLocationUI

//struct City: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//class UserInput: ObservableObject {
//    @Published var destinationStop = ""
//}


//For Wiki
struct ContentView: View {
    
    enum LoadingState{
        case loading, loaded, failed
    }
    @State private var loadingState = LoadingState.loading //default state is currently loading data
    @State private var pages = [Page]() //stores an array of pages

    @AppStorage ("Allow Notifications") var allowNotifications: String = "Allow Notifications"
    @State var accessGranted = false
    private let locationManager = CLLocationManager()
    @StateObject var locationManagers = LocationManager()
    let stops: [Stop] = Bundle.main.decode("stops.json")
    @AppStorage("Stop Index") var selectedStopIndex: Int = 0
    @State var destConfirmation = "Press the button above to be notified"
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
    
    //bar chart horizontal length
   // var barLength = 0
    
    var body: some View {


        let annotations = [
        City(name: "\(stops[selectedStopIndex].name)", coordinate: CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude))]
        let userLat = locationManagers.location?.latitude
        let userLong = locationManagers.location?.latitude
        
//        let coordinate₀ = CLLocation(latitude: locationManagers.location.latitude, longitude: locationManagers.location.latitude)
//        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
//
//        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
//
        
//        let location = locationManagers.location
//
//        let coordinate₀ = (latitude: location.latitude, longitude: location.latitude)
//        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)

            
//
//            LocationButton {
//                locationManagers.requestLocation()
//            }
//            .frame(height: 44)
//            .padding()
        
        VStack{

//            TextField("Enter text here", text: $model.anytext)
//                .padding()
//                .border(Color.black, width: 1)
//                .padding()

            Form{
//                Picker(selection: $selectedStopIndex, label: Text("Select Your stop")) {
//            ForEach(0 ..< stops.count) {
//                Text(self.stops[$0].name)
//
//
//            }
//
//
//        }
//
//
//                Button("\(confirmation) \(stops[selectedStopIndex].name)") {
//                    model.anytext = "\(stops[selectedStopIndex].name)" //MVVM
//                    model.selectedStopIndex = selectedStopIndex
//                    if accessGranted == false{
//                      // allowNotifications = "Please enable notifications"
//                        print("no access ")
//                    }
//                    destConfirmation = "Success! You will be notified when arriving to \(stops[selectedStopIndex].name). Please ensure your notifications are enabled."
//                    print("\(stops[selectedStopIndex].longitude)")
//                   // confirmation = "Success! You will be notified when you arrive to"
//                    let content = UNMutableNotificationContent()
//                    content.title = "Arriving at \(stops[selectedStopIndex].name)"
//                    content.subtitle = "This is your stop."
//                    content.categoryIdentifier = "stop"
//                    content.sound = UNNotificationSound.default
//
//                   //sets geofence
//                    let center = CLLocationCoordinate2D(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)
//
//                    let region = CLCircularRegion(center: center, radius: 500, identifier: "Headquarters")
//                    region.notifyOnEntry = true //notify user when they enter
//                    region.notifyOnExit = false //do not notify when they exit
//
//                    //when user enters, trigger notification
//                    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//
//                   //  choose a random identifier
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                   //print("waiting to enter location")
//
//                    // add our notification request
//                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//                    UNUserNotificationCenter.current().add(request)
//
//
//                    //for other view:
//                    self.input.destinationStop = stops[selectedStopIndex].name
//                   // pop.toggle()
//                }
//                Text("\(destConfirmation)")
//                       .fixedSize(horizontal: false, vertical: true)
//                switch locationViewModel.authorizationStatus {
//                        case .notDetermined:
//                            AnyView(RequestLocationView())
//                                .environmentObject(locationViewModel)
//                        case .authorizedAlways:
//                            TrackingView()
//                                .environmentObject(locationViewModel)
//                        default:
//                            Text("Unexpected status. Please change CalAlert's location permission to Always in your phone settings.")
//                        }
//

               // buttonAlert()
               //Text("\(confirmation)")
                Section("Destination Stats"){
                    HStack{
                        Text("Destination Latitude:")
                        Spacer()
                        Text("\(stops[selectedStopIndex].latitude)")
                    }
                    HStack{
                        Text("Destination Longitude:")
                        Spacer()
                        Text("\(stops[selectedStopIndex].longitude)")
                    }
                    //Distance from the destinatin
                    VStack(alignment: .leading){
                    HStack{
                        Text("Distance from destination:")
                        Spacer()
                        if let location = locationManagers.location {
                            let userCoor = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            let destCoor = CLLocation(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)
                            let distanceInMeters = ((userCoor.distance(from: destCoor)))
                            let distanceInMiles = distanceInMeters/1609.344
                            Text("\(String(format: "%.2f", distanceInMiles)) miles")
                            
                        }
                    }
                    if let location = locationManagers.location {
                        let userCoor = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        let destCoor = CLLocation(latitude: stops[selectedStopIndex].latitude, longitude: stops[selectedStopIndex].longitude)
                        let distanceInMeters = ((userCoor.distance(from: destCoor)))
                        let distanceInMiles = distanceInMeters/1609.344
                        let barLength = 0
                        
                        ZStack(alignment: .leading){
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemGray5))
                                    .frame(width: geometry.size.width, height: 30)
                            }
                                
                        if distanceInMiles >= 25
                        {
                            
                          //  ZStack(alignment: .leading){
                            GeometryReader { geometry in
                                let barLength = distanceInMiles * 8.5
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red)
                                    .frame(width: geometry.size.width * (0.0029 * distanceInMiles*8.5), height: 30)
                           // width: geometry.size.width * 0.33
                            }
                            
                            
                                
                              //  HStack{
                                //Image(systemName: "train.side.rear.car").position(x: barLength-23, y: 23)
                                  //  .font(.system(size: 40))
                                //}
                           // }
                               
                            
                        } else if distanceInMiles >= 10{
                            GeometryReader { geometry in
                                let barLength = distanceInMiles
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.yellow)
                                    .frame(width: geometry.size.width * (0.0029 * distanceInMiles*8.5), height: 30)
                            }
                        } else{
                            GeometryReader { geometry in
                                let barLength = distanceInMiles
                                RoundedRectangle(cornerRadius: 15)
                                  .fill(Color.green)
                                  .frame(width: geometry.size.width * (0.0029 * distanceInMiles*8.5), height: 30)
                            }
                        }
                            
                            HStack{
                            Text("0 miles")
                                    .offset(y: 40)
                                Spacer()
                                Text("40+ miles")
                                    .offset(y: 40)
                            }
//                            GeometryReader { geometry in
//                                HStack(spacing: 0) {
//                                    Text("Left")
//                                        .font(.largeTitle)
//                                        .foregroundColor(.black)
//                                        .frame(width: geometry.size.width * 0.33)
//                                        .background(Color.yellow)
//                                    Text("Right")
//                                        .font(.largeTitle)
//                                        .foregroundColor(.black)
//                                        .frame(width: geometry.size.width * 0.67)
//                                        .background(Color.orange)
//                                }
//                            }
                    }
                        Spacer()
                        Text("\n")
                        
                    }
                    }
                    //Open destination in Maps
                    Button(
                      "Open in Maps",
                      action: {
                          let url = URL(string: "maps://?saddr=&daddr=\(stops[selectedStopIndex].latitude),\(stops[selectedStopIndex].longitude)")
                          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                      }
                    )
                }
                Section("Places to visit near your destination"){
                    switch loadingState {
                    case .loading:
                        Text("loading")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description) //the + will add this all to one line
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
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

////           ZStack
////           {
////            Color(red: 1, green: 0.55, blue: 0.55)
////
////               VStack(spacing: 0){
////                //for wiki
//////                Form{
//////                    Section("Nearby..."){
//////                        switch loadingState {
//////                        case .loading:
//////                            Text("loading")
//////                        case .loaded:
//////                            ForEach(pages, id: \.pageid) { page in
//////                                Text(page.title)
//////                                    .font(.headline)
//////                                + Text(": ")
//////                                + Text("Page description here") //the + will add this all to one line
//////                                    .italic()
//////                            }
//////                        case .failed:
//////                            Text("Please try again later.")
//////                        }
//////                    }
//////                }
////
//////                Image(systemName: "tram.fill")
//////                Text("Your stop: ").bold()
//////                Text("\(stops[selectedStopIndex].name)").bold().font(.largeTitle)//.font(.system(size: 20))
//////                Text("\(destConfirmation)")
//////                       .fixedSize(horizontal: false, vertical: true)
//////                       .multilineTextAlignment(.center)
//////                Text("Latitude: ").bold() + Text("\(stops[selectedStopIndex].latitude)")
//////                Text("Longitude: ").bold() + Text("\(stops[selectedStopIndex].longitude)")
//////        switch locationViewModel.authorizationStatus {
//////                case .notDetermined:
//////                    AnyView(RequestLocationView())
//////                        .environmentObject(locationViewModel)
////////                case .restricted:
////////                    ErrorView(errorText: "Location use is restricted.")
////////                case .denied:
////////                    ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
////////                case .authorizedWhenInUse:
////////                    ErrorView(errorText: "Location is only enabled while app is in use. Please enable to Always Allow in your phone settings.").fixedSize(horizontal: false, vertical: true)
//////
//////                case .authorizedAlways:
//////                    TrackingView()
//////                        .environmentObject(locationViewModel)
//////                default:
//////                    Text("Unexpected status. Please change CalAlert's location permission to Always Allow in your phone settings.")
//////                }
////
////
////
////            Button(allowNotifications) {
////                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
////                    if success {
////                        print("All set!")
////                        allowNotifications = "" //"Notifications enabled!"
////                        accessGranted = true
////                    } else if let error = error {
////                        print(error.localizedDescription)
////                        //allowNotifications = "Please enable notifications"
////                    }
//////                    else if accessGranted == false{
//////                       allowNotifications = "Please enable notifications"
//////
//////
//////                    }
////                }
////            }
////
////
////            }
////
////           }
////           .frame(maxHeight: 100)
//
//
//
//
//
////            VStack{
////              //  Spacer()
////            Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: annotations)
////            {
////                MapPin(coordinate: $0.coordinate)
////            }
////
////            }
//
//

        }


}
    
    
        //wiki nearby places
    func fetchNearbyPlaces() async {
    let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(stops[selectedStopIndex].latitude)%7C\(stops[selectedStopIndex].longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
       // let urlString = "http://api.511.org/transit/StopMonitoring?api_key=0f06edc5-508b-4ea1-b418-4484eb2db1b6&agency=CT&stopPointRef=70111&stopPointName=Hillsdale%20Caltrain%20Station"
        
    
        
    
        

        guard let url = URL(string: urlString) else{
            print("Bad URL: \(urlString)")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted {$0.title < $1.title}
            loadingState = .loaded
        } catch{
            loadingState = .failed
        }
    }


}
//
////    struct RequestLocationView: View {
////        @EnvironmentObject var locationViewModel: LocationViewModel
////
////        var body: some View {
////            VStack {
////                Image(systemName: "location.circle")
////                    .resizable()
////                    .frame(width: 100, height: 100, alignment: .center)
////                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
////                Button(action: {
////                    locationViewModel.requestPermission()
////                }, label: {
////                    Label("Allow tracking to begin", systemImage: "location")
////                })
////                .padding(10)
////                .foregroundColor(.white)
////                .background(Color.blue)
////                .clipShape(RoundedRectangle(cornerRadius: 8))
////                Text("We need your permission to alert you based on your location.")
////                    .foregroundColor(.gray)
////                    .font(.caption)
////            }
////        }
////}
////
////struct ErrorView: View {
////    var errorText: String
////
////    var body: some View {
////        VStack {
////            Image(systemName: "xmark.octagon")
////                    .resizable()
////                .frame(width: 100, height: 100, alignment: .center)
////            Text(errorText)
////        }
////        .padding()
////        .foregroundColor(.white)
////        .background(Color.red)
////    }
////}
////
////struct TrackingView: View {
////    @EnvironmentObject var locationViewModel: LocationViewModel
////
////    var body: some View {
//////        Text("Permission Tracking Enabled")
////        Text("Permission tracking is enabled to Always and is working as expected!")
////    }
////}

