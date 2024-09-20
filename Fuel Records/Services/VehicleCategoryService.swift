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
}
