//
//  AuthViewModel.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
    
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch{
            print("DEBUG: failed to login with error\(error.localizedDescription)")
        }
        
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, coach: Bool) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id:result.user.uid,fullname:fullname, email: email, coach: false, crews:[])
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
            await fetchUser()
        } catch{
            print("Debug: failed to create user with error\(error.localizedDescription)")
        }
        
    }
    func createCoachUser(withEmail email: String, password: String, fullname: String, coach: Bool) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id:result.user.uid,fullname:fullname, email: email, coach: true, crews:[])
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
            await fetchUser()
        } catch{
            print("Debug: failed to create user with error\(error.localizedDescription)")
        }
    }
    func signOut(){
        do{
            try Auth.auth().signOut()// signes out backend
            self.userSession = nil // wipes session
            self.currentUser = nil // wipes current user model for next login
        } catch{
            print("DEBUG: failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    func deleteAccount() async throws {
        do {
            // Get current user
            guard let user = Auth.auth().currentUser else {
                print("DEBUG: No user currently signed in")
                return
            }
            
            // Delete user document from Firestore
            try await Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .delete()
            
            // Delete the user's authentication account
            try await user.delete()
            
            // Clear local user data
            self.userSession = nil
            self.currentUser = nil
            
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
            throw error
        }
    }
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as:User.self)
    }
}

