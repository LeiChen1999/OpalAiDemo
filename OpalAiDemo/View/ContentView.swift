//
//  ContentView.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isSignedIn = false
    
    var body: some View {
        if isSignedIn {
            MockiView()
        } else {
            SignInView(isSignedIn: $isSignedIn)
        }
    }
}



