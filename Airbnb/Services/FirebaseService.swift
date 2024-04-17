//
//  FirebaseService.swift
//  Airbnb
//
//  Created by Gia Huy on 16/02/2024.
//

import Foundation
import FirebaseFirestore

final class FirebaseService {
    init() {}
    struct Constants {
        static let db = Firestore.firestore()
    }
    
    @MainActor public func getAllDoc(completion: @escaping (Result<[AirbnbListing], Error>) -> Void) {
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "userId") ?? ""
        Constants.db.collection("AirbnbListing").whereField("host_id", isEqualTo: id).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                let list: [AirbnbListing] = snapshot.documents.map { doc in
                    return AirbnbListing(id: doc["id"] as! String,
                                         name: doc["name"] as? String ?? "",
                                         host_name: doc["host_name"] as? String ?? "",
                                         images: doc["images"] as? [String] ?? [],
                                         guests: doc["guests"] as? Int ?? 0,
                                         bedrooms: doc["bedrooms"] as? Int ?? 0,
                                         beds: doc["beds"] as? Int ?? 0,
                                         baths: doc["baths"] as? Int ?? 0,
                                         price: doc["price"] as? Int ?? 0,
                                         lon: doc["lon"] as? Double ?? 0,
                                         lat: doc["lat"] as? Double ?? 0,
                                         amenities: doc["amenities"] as? [String] ?? [],
                                         number_of_reviews: doc["number_of_reviews"] as? Int ?? 0,
                                         reviews_rating: doc["reviews_rating"] as? Double ?? 0,
                                         updated_date: doc["updated_date"] as? String ?? "",
                                         state: doc["state"] as? String ?? "")
                }
                completion(.success(list))
            }
        }
    }
    
    @MainActor public func addADoc(item: AirbnbListing) {
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "userId") ?? ""
        Constants.db.collection("AirbnbListing").addDocument(data: [
            "id":item.id,
            "name":item.name ?? "",
            "host_id":id,
            "host_name":item.host_name ?? "",
            "images":item.images ?? [""],
            "guests":item.guests ?? 0,
            "bedrooms":item.bedrooms ?? 0,
            "beds":item.beds ?? 0,
            "baths":item.baths ?? 0,
            "price":item.price ?? 0,
            "lon":item.lon ?? 0,
            "lat":item.lat ?? 0,
            "amenities":item.amenities ?? [""],
            "number_of_reviews":item.number_of_reviews ?? 0,
            "reviews_rating":item.reviews_rating ?? 0,
            "updated_date":item.updated_date ?? "",
            "state":item.state ?? ""
        ]) { error in
            if error == nil {} else {
                return
            }
        }
    }
    
    public func deleteDocWithId(id: String) async {
        do {
            let defaults = UserDefaults.standard
            let uid = defaults.string(forKey: "userId") ?? ""
            let querySnapshot = try await Constants.db.collection("AirbnbListing")
                .whereField("id", isEqualTo: id)
                .whereField("host_id", isEqualTo: uid).getDocuments()
            try await Constants.db.collection("AirbnbListing").document(querySnapshot.documents.first?.documentID ?? "").delete()
        } catch {}
    }
    
    public func findItemWithId(id: String) async -> Bool {
        do {
            let defaults = UserDefaults.standard
            let uid = defaults.string(forKey: "userId") ?? ""
            let querySnapshot = try await Constants.db.collection("AirbnbListing")
                .whereField("id", isEqualTo: id)
                .whereField("host_id", isEqualTo: uid).getDocuments()
            if querySnapshot.documents.isEmpty {
                return false
            }
        } catch {
            return false
        }
        return true
    }
}
