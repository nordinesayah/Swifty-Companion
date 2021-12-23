//
//  APIService.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    private var token: Token?
    
    func getToken() {
        guard let url = URL(string: "\(API_URL)/oauth/token") else { return }
        var request = URLRequest(url: url)
        let body = "grant_type=client_credentials&client_id=\(API_UID)&client_secret=\(API_SECRET)"
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        JSONService.shared.get(request: request, for: Token.self) { token in
            self.token = token
        }
    }
    
    func getUser(_ login: String, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: "\(API_URL)/users/\(login)") else {return}
        var request = URLRequest(url: url)
        guard let token = token?.token else {return}
        print(token)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        JSONService.shared.get(request: request, for: User.self, completion: completion)
    }
    
    func getUserCoa(_ login: String, completion: @escaping ([Coalition]?) -> Void) {
        guard let url = URL(string: "\(API_URL)/users/\(login)/coalitions") else {return}
        var request = URLRequest(url: url)
        guard let token = token?.token else {return}
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        JSONService.shared.get(request: request, for: [Coalition].self, completion: completion)
    }
    
}
