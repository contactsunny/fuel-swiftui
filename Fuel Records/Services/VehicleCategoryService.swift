//
//  VehicleCategoryService.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import Foundation

@Observable
class VehicleCategoryService {
    
    private var httpUtil: HttpUtil = HttpUtil()
    
    func getVehicleCategories() async -> [VehicleCategory]? {
        var vehicleCategories: [VehicleCategory]?
        let data = await self.httpUtil.makeGetCall(endpoint: "vehicleCategory")
        let decoder = JSONDecoder()
        
        do {
            let vehicleCategoriesResponse = try decoder.decode(VehicleCategoriesApiResponse.self, from: data!)
            vehicleCategories = vehicleCategoriesResponse.data
        } catch let error {
            print(error)
        }
        
        return vehicleCategories
    }
    
    func saveVehicleCategory(category: VehicleCategoryRequest) async -> VehicleCategory? {
        do {
            let jsonData = try JSONEncoder().encode(category)
            let data = await self.httpUtil.makePostCall(endpoint: "vehicleCategory", data: jsonData)
            let decoder = JSONDecoder()
            let categoryResponse = try decoder.decode(VehicleCategoryPostApiResponse.self, from: data!)
            return categoryResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func updateVehicleCategory(category: VehicleCategoryRequest) async -> VehicleCategory? {
        do {
            let jsonData = try JSONEncoder().encode(category)
            let data = await self.httpUtil.makePutCall(endpoint: "vehicleCategory/\(category.id ?? "")", data: jsonData)
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehicleCategoryPostApiResponse.self, from: data!)
            return vehicleResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func deleteVehicleCategory(id: String) async {
        do {
            let _ = await self.httpUtil.makeDeleteCall(endpoint: "vehicleCategory/\(id)")
        } catch let error {
            print(error)
        }
    }
}
