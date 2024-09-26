//
//  Preferences.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import Foundation

@Observable
class Preferences: Identifiable, Decodable, Encodable {
    
    var id: String?
    var userId: String?
    var defaultVehicleId: String?
    var defaultFuelType: String?
    var defaultPaymentType: String?
    
    enum CodingKeys: CodingKey {
        case id
        case userId
        case defaultVehicleId
        case defaultFuelType
        case defaultPaymentType
        case _$observationRegistrar
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.defaultVehicleId = try container.decodeIfPresent(String.self, forKey: .defaultVehicleId)
        self.defaultFuelType = try container.decodeIfPresent(String.self, forKey: .defaultFuelType)
        self.defaultPaymentType = try container.decodeIfPresent(String.self, forKey: .defaultPaymentType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(defaultVehicleId, forKey: .defaultVehicleId)
        try container.encode(defaultFuelType, forKey: .defaultFuelType)
        try container.encode(defaultPaymentType, forKey: .defaultPaymentType)
    }
    
    internal init () {
        self.id = nil
        self.userId = nil
        self.defaultVehicleId = nil
        self.defaultFuelType = nil
        self.defaultPaymentType = nil
    }
}
