//
//  AuthenticatedView.swift
//  Airbnb
//
//  Created by Gia Huy on 15/04/2024.
//

import SwiftUI

struct AuthenticatedView: View {
    let content: AnyView
    @StateObject private var authVm = AuthenticationViewModel()
    @State private var presentingLoginScreen = false
    
    var body: some View {
        switch authVm.authenticationState {
        case .unauthenticated, .authenticating:
            VStack(alignment: .leading, spacing: 10) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Login to start explore more place")
                    .padding(.vertical)
                Button {
                    authVm.reset()
                    presentingLoginScreen.toggle()
                } label: {
                    Text("Log in")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 40)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
            }
            .sheet(isPresented: $presentingLoginScreen) {
                AuthenticationView()
                    .environmentObject(authVm)
            }
            
        case .authenticated:
            content
                .environmentObject(authVm)
        }
    }
}

#Preview {
    AuthenticatedView(content: AnyView(ProfileView()))
}
