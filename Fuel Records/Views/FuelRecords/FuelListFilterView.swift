//
//  FuelListFilterView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI

struct FuelListFilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var shouldRefreshList: Bool
    @Binding var showFilterSection: Bool
    @Binding var vehicles: [Vehicle]
    @Binding var vehicleCategories: [VehicleCategory]
    @Binding var fuelTypes: [String]
    @Binding var paymentMethods: [String]
    @Binding var criteria: FuelFilterCriteria
    
    var body: some View {
        if showFilterSection {
            NavigationStack {
                List {
                    Section(header: Text("Vehicle Filters")) {
                        Picker("Select Vehicle", selection: $criteria.vehicleId) {
                            Text("All").tag("all")
                            ForEach(vehicles) { vehicle in
                                Text(vehicle.name).tag(vehicle.id)
                            }
                        }
                        
                        Picker("Vehicle Category", selection: $criteria.vehicleCategoryId) {
                            Text("All").tag("all")
                            ForEach(vehicleCategories) { category in
                                Text(category.name).tag(category.id)
                            }
                        }
                    }
                     
                    Section(header: Text("Fuel Filters")) {
                        Picker("Fuel", selection: $criteria.fuelType) {
                            Text("All").tag("all")
                            ForEach(fuelTypes, id: \.self) { fuelType in
                                Text(CustomUtil.getFormattedString(str: fuelType)).tag(fuelType)
                            }
                        }
                    }
                        
                    Section(header: Text("Payment Filter")) {
                        Picker("Payment Method", selection: $criteria.paymentType) {
                            Text("All").tag("all")
                            ForEach(paymentMethods, id: \.self) { paymentMethod in
                                Text(CustomUtil.getFormattedString(str: paymentMethod)).tag(paymentMethod)
                            }
                        }
                    }
                     
                    Section(header: Text("Date Filters")) {
                        DatePicker(
                            selection: $criteria.startDate,
                            displayedComponents: .date
                        ) {
                            Text("From Date")
                        }
                        
                        DatePicker(
                            selection: $criteria.endDate,
                            displayedComponents: .date
                        ) {
                            Text("To Date")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Reset") {
                            criteria = FuelFilterCriteria()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            shouldRefreshList = true
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct FuelFilterCriteria {
    
    var vehicleId: String
    var vehicleCategoryId: String
    var startDate: Date
    var endDate: Date
    var fuelType: String
    var paymentType: String
    
    internal init(
        vehicleId: String = "all",
        vehicleCategoryId: String = "all",
        startDate: Date = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: CustomUtil.addOrSubtractMonth(month: -6))!,
        endDate: Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!,
        fuelType: String = "all",
        paymentType: String = "all"
    ) {
        self.vehicleId = vehicleId
        self.vehicleCategoryId = vehicleCategoryId
        self.startDate = startDate
        self.endDate = endDate
        self.fuelType = fuelType
        self.paymentType = paymentType
    }
}

#Preview {
    var vehicles: [Vehicle] = []
    var vehicleCategories: [VehicleCategory] = []
    
    FuelListFilterView(
        shouldRefreshList: .constant(true),
        showFilterSection: .constant(true),
        vehicles: .constant(vehicles),
        vehicleCategories: .constant(vehicleCategories),
        fuelTypes: .constant(["DIESEL", "PETROL"]),
        paymentMethods: .constant(["UP", "CREDIT_CARD", "DEBIT_CARD"]),
        criteria: .constant(FuelFilterCriteria())
    ).task {
        vehicles.append(
            Vehicle(id: "someID", name: "Car", vehicleNumber: "alsdkfj", vehicleCategory: VehicleCategory(id: "someID", name: "Car"))
        )
        vehicles.append(
            Vehicle(id: "someOtherID", name: "Bike", vehicleNumber: "asdfalksj", vehicleCategory: VehicleCategory(id: "someOtherID", name: "Bike"))
        )
        vehicleCategories.append(VehicleCategory(id: "someID", name: "Car"))
        vehicleCategories.append(VehicleCategory(id: "someOtherID", name: "Bike"))
    }
}
