//
//  FavoritesListViewModel.swift
//  Airbnb
//
//  Created by Gia Huy on 16/02/2024.
//

import Foundation

final class FavoritesListViewModel: ObservableObject {
    
    private let service = FirebaseService()
   
    @Published var favoriteList: [AirbnbListing] = []
    
    public func getFavoriteList() {
        DispatchQueue.main.async {
            self.service.getAllDoc { [weak self] result in
                switch result {
                case .success(let models):
                    self?.favoriteList = models
                case .failure:
                    break
                }
            }
        }
    }
}
