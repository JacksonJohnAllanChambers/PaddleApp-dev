//
//  CreateTeamView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-28.
//

import SwiftUI

struct CreateTeamView: View {
    @State private var teamName: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Create a New Team")
                .font(.largeTitle)
                .bold()
                .padding()

            InputView(text: $teamName, title: "Team Name", placeholder: "Enter team name")
                .padding()

            Button(action: {
                // Save the team to Firestore
                if let user = viewModel.currentUser {
                    let newTeam = DragonBoatTeam(
                        id: UUID().uuidString,
                        crewname: teamName,
                        coachname: user.fullname,
                        members: []
                    )
                    TeamHandling().createTeam(team: newTeam) { result in
                        switch result {
                        case .success:
                            print("Team created successfully!")
                            dismiss() // Dismiss the view after creation
                        case .failure(let error):
                            print("Failed to create team: \(error.localizedDescription)")
                        }
                    }
                }
            }) {
                Text("Create Team")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(teamName.isEmpty)
            .opacity(teamName.isEmpty ? 0.5 : 1.0)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CreateTeamView()
}
