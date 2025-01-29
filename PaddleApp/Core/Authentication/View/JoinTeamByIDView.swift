//
//  JoinTeamByIDView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-28.
//

import SwiftUI

struct JoinTeamByIdView: View {
    @State private var teamId: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Image("PaddleApp")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)

            VStack(spacing: 24) {
                InputView(text: $teamId, title: "Team ID", placeholder: "Enter team ID")
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            Button {
                if let userId = viewModel.currentUser?.id {
                    TeamHandling().joinTeam(teamId: teamId, userId: userId) { result in
                        switch result {
                        case .success:
                            print("Joined team successfully!")
                            dismiss()
                        case .failure(let error):
                            print("Failed to join team: \(error.localizedDescription)")
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Join Team")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)

            Spacer()
        }
    }
}
#Preview {
    JoinTeamByIdView()
}
