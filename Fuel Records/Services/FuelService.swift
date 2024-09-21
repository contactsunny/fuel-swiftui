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
        let startDateString = CustomUtil.getFormattedDateString(date: CustomUtil.addOrSubtractMonth(month: -3), startTime: true)
        let endDateString = CustomUtil.getFormattedDateString(date: CustomUtil.addOrSubtractDay(day: 1), startTime: false)
        
        var fuelRecords: [Fuel]?
        let data = await self.httpUtil.makeGetCall(endpoint: "fuel?startDate=\(startDateString)&endDate=\(endDateString)")
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
    
    func saveFuelRecord(fuel: FuelRequest) async -> Fuel? {
        do {
            let jsonData = try JSONEncoder().encode(fuel)
            let data = await self.httpUtil.makePostCall(endpoint: "fuel", data: jsonData)
            let decoder = JSONDecoder()
            let fuelResponse = try decoder.decode(FuelPostApiResponse.self, from: data!)
            return fuelResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func updateFuelRecord(fuel: FuelRequest) async -> Fuel? {
        do {
            let jsonData = try JSONEncoder().encode(fuel)
            let data = await self.httpUtil.makePutCall(endpoint: "fuel/\(fuel.id ?? "")", data: jsonData)
            let decoder = JSONDecoder()
            let fuelResponse = try decoder.decode(FuelPostApiResponse.self, from: data!)
            return fuelResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func deleteFuelRecord(id: String) async {
        do {
            let _ = await self.httpUtil.makeDeleteCall(endpoint: "fuel/\(id)")
        } catch let error {
            print(error)
        }
    }
}
