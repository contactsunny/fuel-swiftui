//
//  VehicleCategory.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

@Observable
class VehicleCategory: Identifiable, Decodable {
    
    internal enum CodingKeys: CodingKey {
        case id
        case name
        case userId
        case _$observationRegistrar
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.userId = try container.decode(String.self, forKey: .userId)
    }
    
    let id: String
    var name: String
    let userId: String
}
