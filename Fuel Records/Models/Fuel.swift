//
//  Fuel.swift
//  Night Watch
//
//  Created by TG, Srinidhi on 18/09/24.
//

import Foundation

@Observable
class Fuel: Identifiable, Decodable {
    
    internal enum CodingKeys: CodingKey {
        case id
        case userId
        case date
        case vehicleId
        case litres
        case amount
        case costPerLitre
        case fuelType
        case paymentType
        case vehicleCategoryId
        case createdAt
        case updatedAt
        case vehicle
        case _$observationRegistrar
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self._date = try container.decode(Double.self, forKey: .date)
        self._vehicleId = try container.decode(String.self, forKey: .vehicleId)
        self._litres = try container.decode(Double.self, forKey: .litres)
        self._amount = try container.decode(Double.self, forKey: .amount)
        self._costPerLitre = try container.decode(Double.self, forKey: .costPerLitre)
        self._fuelType = try container.decode(String.self, forKey: .fuelType)
        self._paymentType = try container.decode(String.self, forKey: .paymentType)
        self._vehicleCategoryId = try container.decode(String.self, forKey: .vehicleCategoryId)
        self._createdAt = try container.decode(Double.self, forKey: .createdAt)
        self._updatedAt = try container.decodeIfPresent(Double.self, forKey: .updatedAt)
        self.vehicle = try container.decodeIfPresent(Vehicle.self, forKey: .vehicle)
    }
    
    internal init(id: String, userId: String, date: Double, vehicleId: String, litres: Double, amount: Double, costPerLitre: Double, fuelType: String, paymentType: String, vehicleCategoryId: String, createdAt: Double, updatedAt: Double?, vehicle: Vehicle?) {
        self.id = id
        self.userId = userId
        self.date = date
        self.vehicleId = vehicleId
        self.litres = litres
        self.amount = amount
        self.costPerLitre = costPerLitre
        self.fuelType = fuelType
        self.paymentType = paymentType
        self.vehicleCategoryId = vehicleCategoryId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.vehicle = vehicle
    }
    
    let id: String
    let userId: String
    var date: Double
    var vehicleId: String
    var litres: Double
    var amount: Double
    var costPerLitre: Double
    var fuelType: String
    var paymentType: String
    var vehicleCategoryId: String
    var createdAt: Double
    var updatedAt: Double?
    var vehicle: Vehicle?
    
    
}
