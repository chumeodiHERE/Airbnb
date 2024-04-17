//
//  ProfileView.swift
//  Airbnb
//
//  Created by Gia Huy on 13/04/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVm: AuthenticationViewModel
    
    private func signOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "statusLogin")
        authVm.signOut()
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 15) {
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                
                Text(authVm.displayName)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(width: 300, height: 200)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .padding(.vertical, 50)
            
            Divider()
                .padding(.horizontal)
            HStack {
                Image(systemName: "gear")
                
                Text("Setting")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            HStack {
                Image(systemName: "questionmark.circle")
                
                Text("Visit the help center")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            Divider()
                .padding(.horizontal)
            
            Button {
                signOut()
            } label: {
                Text("log out")
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
