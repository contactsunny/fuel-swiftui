//
//  FuelService.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation
//import SwiftUI

@Observable
class FuelService {
    
    private var httpUtil: HttpUtil = HttpUtil()
    private var fuelRecords: [Fuel]?
    
    func getFuelRecords() async -> [Fuel]? {
        let data = await self.httpUtil.makeGetCall(endpoint: "fuel")
        let decoder = JSONDecoder()
        var fuelRecordsResponse: FuelRecordsApiResponse
        do {
            fuelRecordsResponse = try decoder.decode(FuelRecordsApiResponse.self, from: data!)
            fuelRecords = fuelRecordsResponse.data
        } catch let error {
            print(error)
        }
        
        return fuelRecords
    }
}
