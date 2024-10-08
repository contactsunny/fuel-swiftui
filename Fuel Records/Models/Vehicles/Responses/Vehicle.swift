//
//  Vehicle.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation


@Observable
class Vehicle: Identifiable, Decodable {
    
    internal enum CodingKeys: CodingKey {
        case id
        case vehicleCategoryId
        case name
        case vehicleNumber
        case userId
        case vehicleCategory
        case _$observationRegistrar
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self._vehicleCategoryId = try container.decode(String.self, forKey: .vehicleCategoryId)
        self._name = try container.decode(String.self, forKey: .name)
        self._vehicleNumber = try container.decode(String.self, forKey: .vehicleNumber)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.vehicleCategory = try container.decodeIfPresent(VehicleCategory.self, forKey: .vehicleCategory)
    }
    
    internal init (id: String, name: String, vehicleNumber: String, vehicleCategory: VehicleCategory?) {
        self.id = id
        self.name = name
        self.vehicleCategory = vehicleCategory
        self.vehicleCategoryId = ""
        self.vehicleNumber = vehicleNumber
        self.userId = ""
    }
    
    let id: String
    var vehicleCategoryId: String
    var name: String
    var vehicleNumber: String
    let userId: String
    var vehicleCategory: VehicleCategory?
}
