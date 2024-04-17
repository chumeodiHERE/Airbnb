//
//  AirbnbListing.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import Foundation

struct AirbnbListing: Codable, Hashable, Identifiable {
    let id: String
    let name: String?
    let host_name: String?
    let images: [String]?
    let guests: Int?
    let bedrooms: Int?
    let beds: Int?
    let baths: Int?
    let price: Int?
    let lon: Double?
    let lat: Double?
    let amenities: [String]?
    let number_of_reviews: Int?
    let reviews_rating: Double?
    let updated_date: String?
    let state: String?
}

enum amenitiesListing: Int, Codable, Identifiable, Hashable {
    case wifi
    case kitchen
    case washer
    case pets_allowed
    
    var title: String {
        switch self {
        case .kitchen: return "Kitchen"
        case .wifi: return "Wifi"
        case .washer: return "Washer"
        case .pets_allowed: return "Pets allowed"
        }
    }
    var imgName: String {
        switch self {
        case .kitchen: return "frying.pan"
        case .wifi: return "wifi"
        case .washer: return "washer"
        case .pets_allowed: return "pawprint"
        }
    }
    var id: Int { return self.rawValue }
}
