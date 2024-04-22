//
//  CryptoApp.swift
//  Crypto
//
//  Created by Aleksandr Alekseev on 21.04.2024.
//

import SwiftUI
import CryptoKit

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    @Binding var isLoggedIn: Bool
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    func hashString(_ input: String) -> String {
        let hash = Insecure.MD5.hash(data: input.data(using: .utf8) ?? Data())
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func checkCredentials() {
        let usernameHash = hashString(username)
        let passwordHash = hashString(password)
        
        if usernameHash == "21232f297a57a5a743894a0e4a801fc3" && passwordHash == "21232f297a57a5a743894a0e4a801fc3" {
            isLoggedIn = true
        } else {
            showingAlert = true
            alertMessage = "Invalid username or password."
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer(minLength: geometry.size.width * 0.2)
                    VStack {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(Color.gray, lineWidth: 1.0))
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(Color.gray, lineWidth: 1.0))
                        Button(action: {
                            checkCredentials()
                        }) {
                            Text("Login")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }.alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.6)
                    Spacer(minLength: geometry.size.width * 0.2)
                }
                Spacer()
            }
        }
    }
}


@main
struct CryptoApp: App {
    @State private var isLoggedIn = true
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
