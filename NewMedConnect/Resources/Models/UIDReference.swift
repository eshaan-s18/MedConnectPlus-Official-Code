//
//  UIDReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/4/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct UIDReference: Codable {
    
    let userID: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case options
        case path
    }
    
}
