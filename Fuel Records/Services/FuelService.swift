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
    private let vehicleService = VehicleService()
    
    func getFuelRecords() async -> [Fuel]? {
        var fuelRecords: [Fuel]?
        let data = await self.httpUtil.makeGetCall(endpoint: "fuel")
        let decoder = JSONDecoder()
        
        do {
            let vehicles = await vehicleService.getVehicles()
            let fuelRecordsResponse = try decoder.decode(FuelRecordsApiResponse.self, from: data!)
            fuelRecords = fuelRecordsResponse.data
            
            for record in fuelRecords! {
                for vehicle in vehicles! {
                    if record.vehicleId == vehicle.id {
                        record.vehicle = vehicle
                    }
                }
            }
        } catch let error {
            print(error)
        }
        
        return fuelRecords
    }
}
