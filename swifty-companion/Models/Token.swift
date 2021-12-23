//
//  Token.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

struct Token: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
