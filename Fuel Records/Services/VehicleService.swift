//
//  VehicleService.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

@Observable
class VehicleService {
    
    private var httpUtil: HttpUtil = HttpUtil()
    private let vehicleCategoryService = VehicleCategoryService()
    
    func getVehicles() async -> [Vehicle]? {
        var vehicles: [Vehicle]?
        let data = await self.httpUtil.makeGetCall(endpoint: "vehicle")
        let decoder = JSONDecoder()
        
        do {
            let vehicleCategories = await vehicleCategoryService.getVehicleCategories()
            let vehicleApiResponse = try decoder.decode(VehicleApiResponse.self, from: data!)
            vehicles = vehicleApiResponse.data
            
            for vehicle in vehicles! {
                for category in vehicleCategories! {
                    if vehicle.vehicleCategoryId == category.id {
                        vehicle.vehicleCategory = category
                        continue
                    }
                }
            }
        } catch let error {
            print(error)
        }
        
        return vehicles
    }
    
    func saveVehicle(vehicle: VehicleRequest) async -> Vehicle? {
        do {
            let jsonData = try JSONEncoder().encode(vehicle)
            let data = await self.httpUtil.makePostCall(endpoint: "vehicle", data: jsonData)
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehiclePostApiResponse.self, from: data!)
            return vehicleResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func updateVehicle(vehicle: VehicleRequest) async -> Vehicle? {
        do {
            let jsonData = try JSONEncoder().encode(vehicle)
            let data = await self.httpUtil.makePutCall(endpoint: "vehicle/\(vehicle.id ?? "")", data: jsonData)
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehiclePostApiResponse.self, from: data!)
            return vehicleResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
}
