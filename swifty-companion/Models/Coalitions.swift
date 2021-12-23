//
//  Coalitions.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

struct Coalition: Decodable {
    let name: String
    let slug: String
    let image_url: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case name, slug, image_url, color
    }
}
