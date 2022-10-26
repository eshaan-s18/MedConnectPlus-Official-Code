//
//  EmailReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/2/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct EmailReference: Codable {
    
    let email: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case email
        case options
        case path
    }
    
}

