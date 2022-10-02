//
//  DownvoteReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 8/6/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct DownvoteReference: Codable {
    
    let downvotes: [String]?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case downvotes
        case options
        case path
    }
    
}
