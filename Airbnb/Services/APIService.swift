//
//  APIService.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import Foundation

final class APIService {
    init() {}
    struct Constants {
        static let apiUrl = URL(string: "https://run.mocky.io/v3/069ab3cb-a026-4e3e-9938-45b25851dcc6")
    }
    
    public func getPlaceList(completion: @escaping (Result<[AirbnbListing], Error>) -> Void) {
        guard let url = Constants.apiUrl else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AirbnbListingsResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
