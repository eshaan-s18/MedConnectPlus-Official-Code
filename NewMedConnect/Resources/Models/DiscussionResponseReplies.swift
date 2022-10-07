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
    let genderUpvotes: [Int]?
    let ageUpvotes: [Int]?
    let raceUpvotes: [Int]?
    let country: [String]?
    let countryUpvotes: [Int]?

    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case commentTitle
        case repliesDate
        case repliesDownvotes
        case repliesTitle
        case repliesUpvotes
        case repliesUser
        case genderUpvotes
        case ageUpvotes
        case raceUpvotes
        case country
        case countryUpvotes
        
        case options
        case path
    }
    
}
