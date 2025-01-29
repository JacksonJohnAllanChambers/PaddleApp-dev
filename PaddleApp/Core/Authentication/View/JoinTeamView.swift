//
//  JoinTeamView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-19.
//
import SwiftUI

struct JoinTeamView: View {
    @State private var teamId: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Join a Team")
                .font(.largeTitle)
                .bold()
                .padding()

            InputView(text: $teamId, title: "Team ID", placeholder: "Enter team ID")
                .padding()

            Button(action: {
                // Join the team using the team ID
                if let userId = viewModel.currentUser?.id {
                    TeamHandling().joinTeam(teamId: teamId, userId: userId) { result in
                        switch result {
                        case .success:
                            print("Joined team successfully!")
                            dismiss() // Dismiss the view after joining
                        case .failure(let error):
                            print("Failed to join team: \(error.localizedDescription)")
                        }
                    }
                }
            }) {
                Text("Join Team")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(teamId.isEmpty)
            .opacity(teamId.isEmpty ? 0.5 : 1.0)

            Spacer()
        }
        .padding()
    }
}
#Preview {
    JoinTeamView()
}
