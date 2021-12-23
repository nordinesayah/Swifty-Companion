//
//  ProjectsUser.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import Foundation

struct Project: Decodable {
    let name: String
    let slug: String
    let parent_id: Int?
}

struct ProjectsUser: Decodable {
    let final_mark: Int?
    let status: String
    let validated: Bool?
    let project: Project
    let cursus_ids: [Int]
    
    enum CodingKeys: String, CodingKey {
        case final_mark
        case status
        case validated = "validated?"
        case project
        case cursus_ids
    }
}
