//
//  SavedReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/2/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct SavedReference: Codable {
    
    let saved: [String]?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case saved
        case options
        case path
    }
    
}
