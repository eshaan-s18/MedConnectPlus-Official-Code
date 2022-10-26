//
//  YourDiscussionReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/8/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct YourDiscussionReference: Codable {
    
    let yourDiscussionDate: String?
    let yourDiscussionTitle: String?
    let conditionSelected: String?
     

    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case yourDiscussionDate
        case yourDiscussionTitle
        case conditionSelected
        
        case options
        case path
    }
    
}

