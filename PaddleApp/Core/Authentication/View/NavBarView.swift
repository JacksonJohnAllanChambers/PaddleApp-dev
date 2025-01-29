import Foundation
import SwiftUI

struct NavBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                TabView(selection: $selectedTab) {
                    NavigationView {
                        DashBoardView()
                    }
                    .tabItem {
                        Image("PaddleApp24x24")
                            .renderingMode(.template)
                        Text("Dashboard")
                    }
                    .tag(0)
                    
                    NavigationView {
                        FeedView()
                    }
                    .tabItem {
                        Image(systemName: "newspaper")
                        Text("Feed")
                    }
                    .tag(1)
                    
                    Text("") // Placeholder tab item to keep spacing for the button
                        .tabItem {
                            Text("")
                        }
                        .tag(2)
                    
                    NavigationView {
                        ChatView()
                    }
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("Chat")
                    }
                    .tag(3)
                    
                    NavigationView {
                        SettingsView()
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(4)
                }
            }
            
            // Floating record button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("Record Activity")
                    }) {
                        Image(systemName: "record.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.red)
                            .background(Circle().fill(Color.white).shadow(radius: 5))
                    }
                    .offset(y: -1) // Raise above the tab bar
                    Spacer()
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
            .environmentObject(AuthViewModel())
    }
}
