//
//  PreferencesApiResponse.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import Foundation

@Observable
class PreferencesApiResponse: Decodable {
    
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
        self.data = try container.decode(Preferences.self, forKey: .data)
    }
    
    let status: String
    let message: String
    let error: String?
    let data: Preferences
}
