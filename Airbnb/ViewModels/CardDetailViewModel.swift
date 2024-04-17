//
//  CardDetailViewModel.swift
//  Airbnb
//
//  Created by Gia Huy on 17/02/2024.
//

import Foundation

final class CardDetailViewModel: ObservableObject {
    private let firebaseService = FirebaseService()
    
    @MainActor public func addItemToFavorList(item: AirbnbListing) {
        firebaseService.addADoc(item: item)
    }
    
    public func checkItemExistinFavorList(id: String) async -> Bool {
        if await firebaseService.findItemWithId(id: id) == true {
            return true
        } else {
            return false
        }
    }
    
    public func delItemFromFavorList(id: String) async {
        await firebaseService.deleteDocWithId(id: id)
    }
}
