//
//  acknowledgments.swift
//  findUSF
//
//  Created by Ryan Dirajlal on 4/9/21.
//

import SwiftUI
import MessageUI

struct acknowledgments: View {
    var body: some View {
        ZStack
        {
            VStack{
                ScrollView {
                   
                    HStack{
                    Image("ios-marketing")
                        .resizable()
                        .frame(width: 95, height: 95)
                        .cornerRadius(18.0)
                        VStack{
                            HStack{
                        Text("CalAlert")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Version 2.2.1")
                            }
                            Text("By Ryan Dirajlal")
                            
                               
                                
                        }
                        
                    }
                      
                    
                Text("Sources:")
                    .font(.title)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                Text("This app currently utillizes GPS coordinates supplied by Caltrain through 511. It also relies on public data sourced from Wikipedia, which can be found at:")
                    HStack{
                        Image(systemName: "link")
                    Link("Wikipedia APIs", destination: URL(string: "https://en.wikipedia.org/w/api.php")!)
                        
                    }
                
                    
                    Text("Feedback:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    Text("Thanks for trying this app! I'm Ryan and a current Computer Science major at the University of San Francisco. I made this app, because I understand the struggle of forgetting my stop while distracted on the train with my headphones in. I hope this can help solve the common problem of missing destinations due to our eyes being glued to our phones.")
                    Text("Email Me: ")
                    Link(destination: URL(string: "mailto:ryan@dirajlal.com")!)
                    {
                        Image(systemName: "envelope.circle")
                            .font(.system(size: 60))
                    }
                    
                    
                    HStack{
                    Image(systemName: "link")
                    Link("Please click here for my Privacy Policy", destination: URL(string: "https://ryan6140.wixsite.com/hilltophistory/about")!).padding()
                        
                    }
                    
                    Text("***Please note, CalAlert is not affiliated with any organization, including Caltrain and 511. This app includes zero content owned by any organization, and the app is independently owned by Ryan Dirajlal.")
                    
                    
                
                }

                
            }
        }
        .navigationTitle("Acknowledgments")
        .padding(.horizontal)
    }
    
}


struct acknowledgments_Previews: PreviewProvider {
    static var previews: some View {
        acknowledgments()
    }
}
