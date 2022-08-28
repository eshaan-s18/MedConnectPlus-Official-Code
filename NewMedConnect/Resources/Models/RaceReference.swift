//
//  RaceReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/4/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct RaceReference: Codable {
    
    let race: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case race
        case options
        case path
    }
    
}
