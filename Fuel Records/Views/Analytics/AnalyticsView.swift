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
    @State var showProgressView: Bool = false
    
    let fuelService = FuelService()
    
    @State var showFilterSheet: Bool = false
    @State var fromDate: Date = Calendar.current.date(
        bySettingHour: 00, minute: 00, second: 00, of: CustomUtil.addOrSubtractMonth(month: -6)
    )!
    @State var toDate: Date = Calendar.current.date(
        bySettingHour: 23, minute: 59, second: 59, of: Date()
    )!
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            NavigationView {
                List {
                    Section(header: Text("Vehicles")) {
                        NavigationLink(destination: SpendByVehicleAnalyticsView(fuelRecords: $fuelRecords)) {
                            Text("Spend By Vehicle")
                        }
                        
                        NavigationLink(destination: SpendByVehicleCategoryAnalyticsView(fuelRecords: $fuelRecords)) {
                            Text("Spend By Vehicle Category")
                        }
                    }
                    
                    Section(header: Text("Fuel")) {
                        NavigationLink(destination: SpendByFuelTypeAnalyticsView(fuelRecords: $fuelRecords)) {
                            Text("Spend By Fuel Type")
                        }
                        
                        NavigationLink(destination: FuelCostTrendAnalyticsView(fuelRecords: $fuelRecords)) {
                            Text("Fuel Cost Trend")
                        }
                    }
                    
                    Section(header: Text("Month")) {
                        NavigationLink(destination: SpendPerMonthAnalyticsView(fuelRecords: $fuelRecords)) {
                            Text("Spend By Month")
                        }
                    }
                }
                .navigationTitle(Text("Reports"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showFilterSheet = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .sheet(isPresented: $showFilterSheet,
                       onDismiss: {
                    showFilterSheet = false
                }) {
                    NavigationStack {
                        AnalyticsFilterView(fromDate: $fromDate, toDate: $toDate)
                            .presentationDetents(
                                [.height(250), .large]
                            )
                    }
                }
            }
            .task {
                await refreshList()
            }
            .onChange(of: fromDate) {
                Task {
                    await refreshList()
                }
            }
            .onChange(of: toDate) {
                Task {
                    await refreshList()
                }
            }
        }
    }
    
    func refreshList() async {
        showProgressView = true
        Task {
            fuelRecords = await fuelService.getFuelRecords(
                fromDate: fromDate, toDate: toDate
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
        showProgressView = false
    }
}

#Preview {
    AnalyticsView()
}
