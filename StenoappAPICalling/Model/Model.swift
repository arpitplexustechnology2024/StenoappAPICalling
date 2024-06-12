//
//  Model.swift
//  StenoappAPICalling
//
//  Created by Arpit iOS Dev. on 12/06/24.
//

import Foundation
import UIKit

// MARK: - HomeUserData
struct HomeUserData {
    var image: String
    var id: String
}

// MARK: - SubCategory
struct SubCategory: Codable {
    let status: Int
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let subCategoryID, name: String
    
    enum CodingKeys: String, CodingKey {
        case subCategoryID = "sub_category_id"
        case name
    }
}
