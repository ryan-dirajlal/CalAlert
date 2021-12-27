//
//  HomeScreenView.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 6/24/21.
//

import SwiftUI

struct HomeScreenView: View {
    //@Binding var pop: Bool
    
    @ObservedObject var input : UserInput
    var body: some View {
     
        Text("\(input.destinationStop)")
        
    }
}

