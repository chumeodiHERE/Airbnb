//
//  RegisterView.swift
//  Airbnb
//
//  Created by Gia Huy on 15/04/2024.
//

import SwiftUI
import Combine

private enum FocusableField: Hashable {
  case email
  case pass
  case comfirm
}

struct RegisterView: View {
    
    @EnvironmentObject var authVm: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    
    private func signUpWithEmailPassword() {
        Task {
            if await authVm.signUpWithEmailPassword() == true {
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
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .padding()
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
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.oneTimeCode)
                .focused($focus, equals: .pass)
                .submitLabel(.next)
                .padding()
                .font(.subheadline)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(.gray)
                    
                }
                .padding()
                .onSubmit {
                    self.focus = .comfirm
                }
            
            SecureField("Comfirm Password", text: $authVm.confirmPassword)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.oneTimeCode)
                .focused($focus, equals: .comfirm)
                .submitLabel(.go)
                .padding()
                .font(.subheadline)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(.gray)
                    
                }
                .padding(.horizontal)
                .onSubmit {
                    signUpWithEmailPassword()
                }
            
            if !authVm.errorMessage.isEmpty {
                VStack(alignment: .leading) {
                    Text(authVm.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
                .padding()
            }
            
            Button {
                signUpWithEmailPassword()
            } label: {
                if authVm.authenticationState != .authenticating {
                    Text("Sign up")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 330, height: 40)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical)
                } else {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
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
                    Text("Already have an account?")
                        .foregroundStyle(.blue)
                    
                    Button {
                        authVm.switchFlow()
                    } label: {
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthenticationViewModel())
}
