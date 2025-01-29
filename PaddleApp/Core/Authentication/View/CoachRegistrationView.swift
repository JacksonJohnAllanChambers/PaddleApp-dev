//
//  CoachRegistrationView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-19.
//

import SwiftUI

struct CoachRegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullname: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack{
            Image("PaddleApp")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            VStack(spacing:24){
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Jackson Chambers")
                
                InputView(text: $password, title: "Password", placeholder: "*********", isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "*********", isSecureField: true)
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName:"checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        
                        }
                        else{
                            Image(systemName:"x.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task{
                    try await viewModel.createCoachUser(withEmail: email, password: password, fullname: fullname, coach:true)
                }
                print("User Register..")
            } label: {
                HStack{
                    Text("Sign up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                    
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top,24)
            
            Spacer()
            
            Button{
                dismiss()
            } label: {
                HStack{
                    Text("Not a Coach?")
                    Text("Athlete Registration")
                        .fontWeight(.bold)
                }
                .font(.system(size:14))
            }

        }
    }
}
extension CoachRegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool{
        return !email.isEmpty
        && !password.isEmpty
        && email.contains("@")
        && password.count > 5
        && !fullname.isEmpty
        && !confirmPassword.isEmpty
        && confirmPassword == password
        
        }
    }
#Preview {
    CoachRegistrationView()
}
