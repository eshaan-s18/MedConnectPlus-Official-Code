//
//  SavedDiscussionReference.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/8/22.
//

import UIKit
import FirebaseFirestoreSwift

public struct SavedDiscussionReference: Codable {
    
    let savedDiscussionDate: String?
    let savedDiscussionSavedDate: String?
    let savedDiscussionTitle: String?
    let conditionSelected: String?
     

    let options: [String]?
    let path : [String]?
    
    enum CodingKeys: String, CodingKey {
        case savedDiscussionDate
        case savedDiscussionSavedDate
        case savedDiscussionTitle
        case conditionSelected
        
        case options
        case path
    }
    
}
