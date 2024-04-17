//
//  AirbnbListingsResponse.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import Foundation

struct AirbnbListingsResponse: Codable {
    let total_count: Int
    let results: [AirbnbListing]
}
