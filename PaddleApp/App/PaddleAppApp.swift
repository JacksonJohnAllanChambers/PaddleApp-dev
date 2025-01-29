//
//  PaddleAppApp.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-18.
//

import SwiftUI
import Firebase

@main
struct PaddleAppApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
