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

// MARK: - DataList
struct DataList: Codable {
    let status: Int
    let data: [SubDataList]
}

// MARK: - SubDataList
struct SubDataList: Codable {
    let id, name, path, path1: String
    let path2, categoryID, subcatID: String
    let extPath: EXTPath
    let extPath1: EXT1Path
    let extPath2: String

    enum CodingKeys: String, CodingKey {
        case id, name, path, path1, path2
        case categoryID = "category_id"
        case subcatID = "subcat_id"
        case extPath = "ext_path"
        case extPath1 = "ext_path1"
        case extPath2 = "ext_path2"
    }
}

enum EXTPath: String, Codable {
    case mp3 = "mp3"
    case pdf = "pdf"
}

enum EXT1Path: Codable {
    case mp3
    case pdf
    case unknown(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "mp3":
            self = .mp3
        case "pdf":
            self = .pdf
        default:
            self = .unknown(value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .mp3:
            try container.encode("mp3")
        case .pdf:
            try container.encode("pdf")
        case .unknown(let value):
            try container.encode(value)
        }
    }
}
