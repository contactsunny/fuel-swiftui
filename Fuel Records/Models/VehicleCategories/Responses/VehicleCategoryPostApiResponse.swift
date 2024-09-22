//
//  VehicleCategoryPostApiResponse.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import Foundation

@Observable
class VehicleCategoryPostApiResponse: Decodable {
    
    internal enum CodingKeys: CodingKey {
        case status
        case message
        case error
        case data
        case _$observationRegistrar
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.message = try container.decode(String.self, forKey: .message)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.data = try container.decode(VehicleCategory.self, forKey: .data)
    }
    
    let status: String
    let message: String
    let error: String?
    let data: VehicleCategory
}
