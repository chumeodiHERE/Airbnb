//
//  MainView.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import SwiftUI
//Màn hình chạy lên đầu tiên, chứa các màn hình nhỏ hơn
struct MainView: View {
    @State var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            //Màn hình hiển thị các địa điểm từ API
            DiscoverableView().tabItem {
                
                if selectedTab == 0 {
                    Image(systemName: "safari")
                        .tint(Color.primary)
                    Text("Explore")
                        .tint(Color.primary)
                } else {
                    Image(systemName: "safari")
                        .tint(Color.secondary)
                    Text("Explore")
                        .tint(Color.secondary)
                }
            }.tag(0)
            
            AuthenticatedView(content: AnyView(FavoritesListView())).tabItem {
                if selectedTab == 1 {
                    Image(systemName: "heart.fill")
                        .tint(Color.primary)
                    Text("Favorites")
                        .tint(Color.primary)
                } else {
                    Image(systemName: "heart.fill")
                        .tint(Color.secondary)
                    Text("Favorites")
                        .tint(Color.secondary)
                }
            }.tag(1)
            
            AuthenticatedView(content: AnyView(ProfileView())).tabItem {
                if selectedTab == 1 {
                    Image(systemName: "person.circle.fill")
                        .tint(Color.primary)
                    Text("Profile")
                        .tint(Color.primary)
                } else {
                    Image(systemName: "person.circle.fill")
                        .tint(Color.secondary)
                    Text("Profile")
                        .tint(Color.secondary)
                }
            }.tag(2)
        })
    }
}

#Preview {
    MainView(selectedTab: 0)
}
