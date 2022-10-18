//
//  DeviceTokenReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/18/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct DeviceTokenReference: Codable {
    
    let deviceToken: String?
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case deviceToken
        case options
        case path
    }
    
}
