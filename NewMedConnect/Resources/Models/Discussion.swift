//
//  Discussion.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/25/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct Discussion: Codable {
    
    let comments: [String]?
    let date: String?
    let discussion: String?
    let views: String?
    let user: String?
    
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case comments
        case date
        case discussion
        case views
        case user
        case options
        case path
    }
    
}
