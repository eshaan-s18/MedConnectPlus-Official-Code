//
//  DiscussionResponseReplies.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 8/25/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct DiscussionResponseReplies: Codable {
    
    let commentTitle: String?
    let repliesDate: String?
    let repliesDownvotes: Int?
    let repliesTitle: String?
    let repliesUpvotes: Int?
    let repliesUser: String?

    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case commentTitle
        case repliesDate
        case repliesDownvotes
        case repliesTitle
        case repliesUpvotes
        case repliesUser
        case options
        case path
    }
    
}
