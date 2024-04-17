//
//  DiscoverableViewModel.swift
//  Airbnb
//
//  Created by Gia Huy on 15/02/2024.
//

import Foundation

@MainActor
class DiscoverableViewModel: ObservableObject {
    @Published var searchContext = ""
    private let apiService = APIService()
    private var listingstemp = [AirbnbListing]()
    
    @Published var listings: [AirbnbListing] = []
    
    init() {
        fetchList()
    }
    
    
    public func fetchList() {
        DispatchQueue.main.async {
            self.apiService.getPlaceList {[weak self] result in
                switch result {
                case .success(let models):
                    self?.listings = models
                    self!.listingstemp = self!.listings
                case .failure:
                    print("fail")
                    break
                }
            }
        }
    }
    
    public func searchPlaceLocation() {
        if listings.isEmpty {
            print("fail")
        } else {
            let filter = listings.filter({$0.name!.lowercased().contains(searchContext.lowercased())})
            self.listings = filter.isEmpty ? listingstemp : filter
        }
    }
}
