//
//  UpvoteReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 8/6/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct UpvoteReference: Codable {
    
    let upvotes: [String]?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case upvotes
        case options
        case path
    }
    
}
