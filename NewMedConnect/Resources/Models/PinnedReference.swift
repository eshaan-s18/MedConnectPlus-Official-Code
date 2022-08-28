//
//  PinnedReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/14/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct PinnedReference: Codable {
    
    let pinned: [String]?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case pinned
        case options
        case path
    }
    
}
