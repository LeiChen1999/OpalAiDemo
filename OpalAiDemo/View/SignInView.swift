//
//  SignInView.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/13/23.
//  com.googleusercontent.apps.542032409876-im5ucmc130f6iq57donu0im7i31ac8mv
//  542032409876-im5ucmc130f6iq57donu0im7i31ac8mv.apps.googleusercontent.com
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignInView: View {
    
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            Text("Sign in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            StyledGoogleSignInButton(action: handleSignInButton)
            if isSignedIn {
                MockiView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isSignedIn, onDismiss: {
            isSignedIn = false
        }, content: {
            MockiView()
        })
    }

    func handleSignInButton() {
        let config = GIDConfiguration(clientID: "542032409876-im5ucmc130f6iq57donu0im7i31ac8mv.apps.googleusercontent.com")

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { user, error in
                guard let user = user else {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    isSignedIn = true
                }
            }
        }
    }
}

struct StyledGoogleSignInButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image("GoogleLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 20)
                Text("Sign in with Google")
                    .foregroundColor(.white)
            }
            .padding(10)
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
}


