//
//  FuelRequest.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

class FuelRequest: Codable {
    
    let id: String?
    let userId: String?
    let date: String
    let fuelType: String
    let litres: Double
    let costPerLitre: Double
    let paymentType: String
    let amount: Double
    let vehicleId: String
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.fuelType, forKey: .fuelType)
        try container.encode(self.litres, forKey: .litres)
        try container.encode(self.costPerLitre, forKey: .costPerLitre)
        try container.encode(self.paymentType, forKey: .paymentType)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.vehicleId, forKey: .vehicleId)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.userId, forKey: .userId)
    }
    
    internal init(id: String?, userId: String?, date: String, fuelType: String, litres: Double, costPerLitre: Double, paymentType: String, amount: Double, vehicleId: String) {
        self.date = date
        self.fuelType = fuelType
        self.litres = litres
        self.costPerLitre = costPerLitre
        self.paymentType = paymentType
        self.amount = amount
        self.vehicleId = vehicleId
        self.id = id
        self.userId = userId
    }
}
