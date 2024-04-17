//
//  DiscoverableView.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import SwiftUI

struct DiscoverableView: View {
    @StateObject var DiscoverableVM = DiscoverableViewModel()
    @StateObject var authVm = AuthenticationViewModel()
    @State var showSearchView = false
    var body: some View {
        NavigationStack {
            if showSearchView {
                DestinationSearchView(show: $showSearchView, vm: DiscoverableVM)
            } else {
                ScrollView {
                    
                    SearchView()
                        .onTapGesture {
                            withAnimation(.snappy) {
                                showSearchView.toggle()
                            }
                        }
                    
                    LazyVStack(spacing: 32) {
                        if DiscoverableVM.listings.isEmpty {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            ForEach(DiscoverableVM.listings, id: \.self) { listing in
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
        }
    }
}

#Preview {
    DiscoverableView()
}
