//
//  AuthenticationView.swift
//  Airbnb
//
//  Created by Gia Huy on 15/04/2024.
//

import SwiftUI
import Combine

struct AuthenticationView: View {
    @EnvironmentObject var authVm: AuthenticationViewModel
    var body: some View {
        VStack {
            switch authVm.flow {
            case .login:
                LoginView()
                    .environmentObject(authVm)
            case .signUp:
                RegisterView()
                    .environmentObject(authVm)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
