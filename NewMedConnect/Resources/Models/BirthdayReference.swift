//
//  BirthdayReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/4/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct BirthdayReference: Codable {
    
    let birthday: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case birthday
        case options
        case path
    }
    
}
