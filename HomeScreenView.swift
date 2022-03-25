//
//  HomeScreenView.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 6/24/21.
//

import SwiftUI
import UserNotifications
import CoreLocation
import MapKit

struct HomeScreenView: View {
    //@Binding var pop: Bool
    
    //@ObservedObject var input : UserInput
    private let locationManager = CLLocationManager()
    @StateObject private var manager = LocationManager()
    @StateObject private var model = MyModel()
    @State var destination = ""
    
    @State private var isSharePresented = false
    @State var sharedText = "Choose a destination to share"
    
    var body: some View {
        
        let annotations = [
            City(name: "\(model.stops[model.selectedStopIndex].name)", coordinate: CLLocationCoordinate2D(latitude: model.stops[model.selectedStopIndex].latitude, longitude: model.stops[model.selectedStopIndex].longitude))]
       
        VStack{
        //Entry().environmentObject(model)
//                NavigationLink {
//                    ContentView().environmentObject(model)
//                } label: {
//                    Text("Select your destination\n and view details")
//                }

            
            
            
            ZStack
            {
             Color(red: 1, green: 0.55, blue: 0.55)
            
                VStack(spacing: 0){
//                    Spacer()
//                 Image(systemName: "tram.fill")
//                 Text("Your stop: ").bold()
                    Spacer()
                //TextDisplayer().environmentObject(model)
                    Text("\(model.anytext)").bold().font(.largeTitle)
                    Spacer()
//                    NavigationLink {
//                        ContentView().environmentObject(model)
//                    } label: {
//                        Text("Select your destination\n and view details")
//                    }
                    
                 
                    Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: annotations)
                    {
                        MapPin(coordinate: $0.coordinate)
                    }.frame(maxHeight:500)

//                    Button("Show details") {
//                        destination = "\((model.anytext))"
//                                }
//                    Text("\(destination)")
//                    Text("\(model.anytext) 2")
                    
             
                 
            
             }
             
            }
            .frame(maxHeight: 800)
         
        }.navigationTitle("Your Stop:")
            .navigationBarItems(leading:   Button(action: {
                sharedText = "I'm on my way to \(model.anytext)!"
                self.isSharePresented = true
            }) {
                Image(systemName: "square.and.arrow.up")
            }.sheet(isPresented: $isSharePresented, onDismiss: {
                print("Dismiss")
            }, content: {
                ActivityViewController(activityItems: [("\(sharedText)")])
            }), trailing: NavigationLink {
                ContentView().environmentObject(model)
            } label: {
                Text("Choose your stop \nand view details").fixedSize(horizontal: false, vertical: true)
            })
            //.toolbar {
//                NavigationLink {
//                    ContentView().environmentObject(model)
//                } label: {
//                    Text("Choose your stop \nand view details").fixedSize(horizontal: false, vertical: true)
//                }
            //}
        
        
    }
}












struct Entry: View {
    @EnvironmentObject private var model: MyModel

    var body: some View {
        VStack {
//            TextField("Enter text here", text: $model.anytext)
//                .padding()
//                .border(Color.black, width: 1)
//                .padding()

            TextDisplayer()
        }
    }
}

struct TextDisplayer: View {
    @EnvironmentObject private var model: MyModel

    var body: some View {
        Text(model.anytext)
    }
}

class MyModel: ObservableObject {
    @Published var anytext = "Choose a destination above"//yourStop text
    @Published var stops: [Stop] = Bundle.main.decode("stops.json")
    @Published var selectedStopIndex: Int = 0
}





//Share Sheet
struct ShareSheet : UIViewControllerRepresentable {
    
    //the data needed to share
   
    
    var items : [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController{
    
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){
        
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
