//
//  UserReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/3/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct UserReference: Codable {
    
    let birthday: String?
    let country: String?
    let gender: String?
    let race: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case birthday
        case country
        case gender
        case race
        case options
        case path
    }
    
}
