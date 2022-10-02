//
//  GenderReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/4/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct GenderReference: Codable {
    
    let gender: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case gender
        case options
        case path
    }
    
}
