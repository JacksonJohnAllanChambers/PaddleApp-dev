//
//  ContentView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                NavBarView()
            }   else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
