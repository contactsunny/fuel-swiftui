//
//  VehicleRequest.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import Foundation

class VehicleRequest: Codable {
    
    let id: String?
    let userId: String?
    let name: String
    let vehicleNumber: String
    let vehicleCategoryId: String
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.vehicleNumber, forKey: .vehicleNumber)
        try container.encode(self.vehicleCategoryId, forKey: .vehicleCategoryId)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.userId, forKey: .userId)
    }
    
    internal init(id: String?, userId: String?, name: String, vehicleNumber: String, vehicleCategoryId: String) {
        self.name = name
        self.vehicleNumber = vehicleNumber
        self.vehicleCategoryId = vehicleCategoryId
        self.id = id
        self.userId = userId
    }
}
