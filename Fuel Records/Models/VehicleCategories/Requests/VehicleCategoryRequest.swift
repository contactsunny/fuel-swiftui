//
//  VehicleCategoryRequest.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import Foundation

class VehicleCategoryRequest: Codable {
    
    let id: String?
    let userId: String?
    let name: String
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.userId, forKey: .userId)
    }
    
    internal init(id: String?, userId: String?, name: String) {
        self.name = name
        self.id = id
        self.userId = userId
    }
}

