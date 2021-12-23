//
//  JSONService.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

class JSONService {
    static let shared = JSONService()
    
    func get<T: Decodable>(request: URLRequest, for type: T.Type, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            DispatchQueue.main.async { completion(result) }
            }.resume()
    }
}
