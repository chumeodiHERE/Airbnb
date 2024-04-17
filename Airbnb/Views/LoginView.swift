//
//  LoginView.swift
//  Airbnb
//
//  Created by Gia Huy on 14/04/2024.
//

import SwiftUI
import Combine

private enum inputField: Hashable {
    case email
    case pass
}

struct LoginView: View {
    
    @EnvironmentObject var authVm: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: inputField?
    
    private func signInWithEmailPassword() {
        Task {
            if await authVm.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image("Airbnb_logo")
                .resizable()
                .frame(width: 300, height: 150)
                .aspectRatio(contentMode: .fit)
            
            TextField("Email", text: $authVm.email)
                .padding()
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .font(.subheadline)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(.gray)
                    
                }
                .padding(.horizontal)
                .onSubmit {
                    self.focus = .pass
                }
            
            SecureField("Password", text: $authVm.password)
                .padding()
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus, equals: .pass)
                .submitLabel(.go)
                .font(.subheadline)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(.gray)
                    
                }
                .padding()
                .onSubmit {
                    signInWithEmailPassword()
                }
            if !authVm.errorMessage.isEmpty {
                VStack(alignment: .leading) {
                    Text(authVm.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
                .padding()
            }
            
            HStack(spacing: 8) {
                Spacer()
                Button {
                    
                } label: {
                    Text("Forgot password")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Button {
                signInWithEmailPassword()
            } label: {
                if authVm.authenticationState != .authenticating {
                    Text("Log in")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 330, height: 40)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!authVm.isValid)
            
            Spacer()
        }
        .padding()
        .toolbar(.hidden, for: .tabBar)
        .overlay(alignment: .bottom) {
            VStack {
                Divider()
                    .padding(.bottom)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.blue)
                    
                    Button {
                        authVm.switchFlow()
                    } label: {
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        LoginView()
    }
    .environmentObject(AuthenticationViewModel())
}
