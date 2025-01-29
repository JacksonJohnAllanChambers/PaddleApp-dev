import SwiftUI
import FirebaseFirestore

struct ActivityPlaceholderCard: View {
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("No scheduled activity")
                        .font(.title3)
                        .bold()
                    
                    Text("Check back later")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "calendar.badge.exclamationmark")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

struct DashBoardView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isNavigatingToJoinTeam = false
    @State private var isNavigatingToCreateTeam = false
    @State private var teams: [DragonBoatTeam] = []
    @State private var nextActivity: Activity?
    @State private var previousActivity: Activity?
    
    var body: some View {
        if let user = viewModel.currentUser {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            isNavigatingToJoinTeam = true
                        }) {
                            Image(systemName: "person.badge.plus")
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                        if user.coach {
                            Button(action: {
                                isNavigatingToCreateTeam = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        Text(user.coach ? "Coach Dashboard" : "Athlete Dashboard")
                            .font(.largeTitle)
                            .bold()
                        HStack {
                            StatisticCircle(title: "Kms This Week", value: "25")
                            StatisticCircle(title: "Stroke Rate Avg", value: "72 spm")
                            StatisticCircle(title: "Km/Hr Avg", value: "12.3")
                        }
                        .padding(.vertical)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if let nextActivity = nextActivity {
                        NavigationLink(destination: ActivityDetailView(activity: nextActivity)) {
                            ActivityPreviewCard(title: "Next Activity", activity: nextActivity, backgroundColor: .blue.opacity(0.1))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    } else {
                        ActivityPlaceholderCard(title: "Next Activity", backgroundColor: .blue.opacity(0.1))
                            .padding(.horizontal)
                    }
                    
                    if let previousActivity = previousActivity {
                        NavigationLink(destination: ActivityDetailView(activity: previousActivity)) {
                            ActivityPreviewCard(title: "Previous Activity", activity: previousActivity, backgroundColor: .gray.opacity(0.1))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    } else {
                        ActivityPlaceholderCard(title: "Previous Activity", backgroundColor: .gray.opacity(0.1))
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My Teams")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                            ForEach(teams) { team in
                                NavigationLink(destination: TeamDetailView(team: team)) {
                                    TeamCardView(team: team)
                                        .frame(maxWidth: .infinity) // Ensure the card stretches across the screen
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(
                Group {
                    NavigationLink("", destination: JoinTeamView(), isActive: $isNavigatingToJoinTeam)
                        .hidden()
                    NavigationLink("", destination: CreateTeamView(), isActive: $isNavigatingToCreateTeam)
                        .hidden()
                }
            )
            .onAppear {
                fetchTeams()
                fetchActivities()
            }
        } else {
            Button {
                viewModel.signOut()
                print("Sign out..")
            } label: {
                SettingsRowView(imageName: "arrow.left.circle.fill", title: "User Session Terminated, Sign Out", tintColor: .red)
            }
            .onAppear {
                print("Fetching user data...")
            }
        }
    }
    
    private func fetchTeams() {
        guard let user = viewModel.currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("teams")
            .whereField("members", arrayContains: user.id) // Filter teams where the user is a member
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching teams: \(error.localizedDescription)")
                    return
                }
                if let documents = snapshot?.documents {
                    self.teams = documents.compactMap { document in
                        try? document.data(as: DragonBoatTeam.self)
                    }
                }
            }
    }
    
    private func fetchActivities() {
        let db = Firestore.firestore()
        let now = Date()
        db.collection("activities")
            .whereField("date", isGreaterThan: now)
            .order(by: "date")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    self.nextActivity = try? document.data(as: Activity.self)
                }
            }
        db.collection("activities")
            .whereField("date", isLessThan: now)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    self.previousActivity = try? document.data(as: Activity.self)
                }
            }
    }
}
// New ActivityPreviewCard component
struct ActivityPreviewCard: View {
    let title: String
    let activity: Activity
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.title)
                        .font(.title3)
                        .bold()
                    
                    Text(formatDate(activity.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
// Original StatisticCircle remains unchanged
struct StatisticCircle: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 100, height: 100)
                Text(value)
                    .font(.headline)
                    .bold()
            }
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}
struct TeamCardView: View {
    let team: DragonBoatTeam
    
    var body: some View {
        HStack {
            if let coverImageURL = team.coverImageURL {
                AsyncImage(url: URL(string: coverImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80) // Adjust the size of the image
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80) // Adjust the size of the image
                    .clipped()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(team.crewname)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer() // Push the text to the left and the image to the right
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity) // Ensure the card stretches across the screen
    }
}
// Original TeamDetailView remains unchanged
struct TeamDetailView: View {
    let team: DragonBoatTeam
    
    var body: some View {
        VStack {
            if let coverImageURL = team.coverImageURL {
                AsyncImage(url: URL(string: coverImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .background(Color.gray.opacity(0.2))
            }
            
            Text(team.crewname)
                .font(.largeTitle)
                .bold()
                .padding(.top, 16)
            
            List {
                Section(header: Text("Coaches")) {
                    Text(team.coachname)
                }
                
                Section(header: Text("Athletes")) {
                    ForEach(team.members, id: \.self) { member in
                        Text(member)
                    }
                }
            }
        }
        .navigationTitle("Team Details")
    }
}
// New ActivityDetailView
struct ActivityDetailView: View {
    let activity: Activity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(activity.title)
                    .font(.title)
                    .bold()
                
                Text(formatDate(activity.date))
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(activity.description)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Activity Details")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// New Activity Model
struct Activity: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let teamId: String
}

// Preview remains unchanged
#Preview {
    class MockAuthViewModel: AuthViewModel {
        override init() {
            super.init()
            self.currentUser = User.MOCK_USER
        }
    }
    
    let mockViewModel = MockAuthViewModel()
    return NavigationView {
        DashBoardView()
            .environmentObject(mockViewModel)
    }
}
