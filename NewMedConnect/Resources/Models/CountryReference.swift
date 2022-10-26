//
//  CountryReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/4/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct CountryReference: Codable {
    
    let country: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case country
        case options
        case path
    }
    
}
