//
//  SettingsView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-19.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showDeleteConfirmation = false
    var body: some View {
        if let user = viewModel.currentUser {
            List{
                Section{
                    HStack{
                        Text(user.initals)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(width:72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing:4){
                            Text(user.fullname)
                                .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top,4)
                            Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray))
                        }
                    }
                }
                
                Section("General"){
                    HStack{
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                    }
                }
                
                Section("Account"){
                    Button {
                        viewModel.signOut()
                        print("Sign out..")
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                    .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                } catch {
                                    print("DEBUG: Error deleting account: \(error.localizedDescription)")
                                }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete your account? This action cannot be undone.")
                    }
                }
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel()
    return NavigationView {
        SettingsView()
            .environmentObject(viewModel)
    }
}

