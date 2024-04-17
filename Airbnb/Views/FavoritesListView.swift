//
//  FavoritesListView.swift
//  Airbnb
//
//  Created by Gia Huy on 16/02/2024.
//

import SwiftUI

struct FavoritesListView: View {
    
    @EnvironmentObject var authVm: AuthenticationViewModel
    @StateObject var FavotitesListVM = FavoritesListViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Wish List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                LazyVStack(spacing: 32) {
                    if FavotitesListVM.favoriteList.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ForEach(FavotitesListVM.favoriteList, id: \.self) { listing in
                            NavigationLink(value: listing) {
                                DiscoverableCardView(model: listing)
                                    .frame(height: 400)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: AirbnbListing.self) { listing in
                CardDetailView(model: listing)
                    .environmentObject(authVm)
                    .navigationBarBackButtonHidden()
            }
        }
        .onAppear(perform: {
            FavotitesListVM.getFavoriteList()
        })
    }
}
#Preview {
    FavoritesListView()
        .environmentObject(AuthenticationViewModel())
}

