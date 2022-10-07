//
//  DiscussionComments.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/10/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct DiscussionComments: Codable {
    
    let commentTitle: String?
    let upvotes: Int?
    let downvotes: Int?
    let user: String?
    let date: String?
    let genderUpvotes: [Int]?
    let ageUpvotes: [Int]?
    let raceUpvotes: [Int]?
    let country: [String]?
    let countryUpvotes: [Int]?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case commentTitle
        case upvotes
        case downvotes
        case user
        case date
        case genderUpvotes
        case ageUpvotes
        case raceUpvotes
        case country
        case countryUpvotes
        case options
        case path
    }
    
}
