//
//  NotificationReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/18/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct NotificationReference: Codable {
    
    let notificationTitle: String?
    let notificationBody: String?
    let notificationDate: String?
    let notificationCondition: String?
    let notificationDiscussion: String?
    
    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case notificationTitle
        case notificationBody
        case notificationDate
        case notificationCondition
        case notificationDiscussion
        case options
        case path
    }
    
}

