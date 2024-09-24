//
//  AnalyticsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI

struct AnalyticsView: View {
    
    @State var fuelRecords: [Fuel] = []
    @State var vehicles: [Vehicle] = []
    @State var vehicleCategories: [VehicleCategory] = []
    @State var fuelTypes: [String] = []
    @State var paymentMethods: [String] = []
    
    let fuelService = FuelService()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Vehicles")) {
                    NavigationLink(destination: CostByVehicleAnalyticsView(fuelRecords: $fuelRecords)) {
                        Text("Spend By Vehicle")
                    }
                    
                    NavigationLink(destination: CostByVehicleCategoryAnalyticsView(fuelRecords: $fuelRecords)) {
                        Text("Spend By Vehicle Category")
                    }
                }
            }.navigationTitle(Text("Reports"))
        }.task {
            await refreshList()
        }
    }
    
    func refreshList() async {
        Task {
            fuelRecords = await fuelService.getFuelRecords(
                fromDate: nil, toDate: nil
            )!
            
            for record in fuelRecords {
                if !fuelTypes.contains(record.fuelType) {
                    fuelTypes.append(record.fuelType)
                }
                
                if !paymentMethods.contains(record.paymentType) {
                    paymentMethods.append(record.paymentType)
                }
                
                guard record.vehicle != nil else { continue }
                let vehicle = record.vehicle!
                if !vehicles.contains(where: { $0.id == vehicle.id }) {
                    vehicles.append(vehicle)
                }
                
                guard record.vehicle!.vehicleCategory != nil else { continue }
                let category = record.vehicle!.vehicleCategory!
                if !vehicleCategories.contains(where: { $0.id == category.id }) {
                    vehicleCategories.append(category)
                }
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
