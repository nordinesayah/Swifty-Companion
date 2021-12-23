//
//  CursusUser.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

struct Cursus: Decodable {
    let name: String
    let slug: String
    let id: Int
}

struct Skills: Decodable {
    let name: String
    let level: Float
}

struct CursusUser: Decodable {
    let level: Float
    let grade: String?
    let cursus: Cursus
    let skills: [Skills]
}
