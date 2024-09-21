//
//  FuelRecordDetailsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordDetailsView: View {
    
    @Binding var fuel: Fuel
    
//    UI Controlling Variables
    @State var shouldShowDeleteAlert: Bool = false
    @State var showEditFuelSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
//                Vehicle Info
                Section(header: Text("Vehicle Info")) {
                    HStack {
                        Text("Vehicle")
                        Spacer()
                        Text("\(fuel.vehicle!.name)")
                    }
                    HStack {
                        Text("Registration Number")
                        Spacer()
                        Text("\(fuel.vehicle!.vehicleNumber)")
                    }
                    HStack {
                        Text("Category")
                        Spacer()
                        Text("\(fuel.vehicle!.vehicleCategory!.name)")
                    }
                }
//                Record Info
                Section(header: Text("Record Info")) {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text("\(CustomUtil.getFormattedDateFromTimestamp(timestamp: fuel.date))")
                    }
                }
//                Fuel Info
                Section(header: Text("Fuel Info")) {
                    HStack {
                        Text("Fule Type")
                        Spacer()
                        Text("\(fuel.fuelType.capitalized)")
                    }
                    HStack {
                        Text("Volume")
                        Spacer()
                        Text("\(fuel.litres, specifier: "%.2f") L")
                    }
                    HStack {
                        Text("Cost Per Litre")
                        Spacer()
                        Text("Rs. \(fuel.costPerLitre, specifier: "%.2f")")
                    }
                }
//                Payment Info
                Section(header: Text("Payment Info")) {
                    
                    HStack {
                        Text("Total Paid")
                        Spacer()
                        Text("Rs. \(fuel.amount, specifier: "%.2f")")
                    }
                    HStack {
                        Text("Payment Method")
                        Spacer()
                        Text("\(CustomUtil.getFormattedString(str: fuel.paymentType))")
                    }
                }
            }
            .navigationTitle(Text("Fuel Log"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        shouldShowDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showEditFuelSheet = true
                    }
                }
            }
            .alert(isPresented: $shouldShowDeleteAlert) {
                Alert(title: Text("Are you sure?"),
                      primaryButton: .cancel(),
                      secondaryButton: .destructive(Text("Yes"), action: {
                    
                }))
            }
            .sheet(isPresented: $showEditFuelSheet,
                   onDismiss: {
                showEditFuelSheet = false
            }) {
                NavigationStack {
                    EditFuelRecordForm(
                        fuel: $fuel
                    )
                    .navigationTitle("Edit Fuel Log")
                }.onDisappear() {
//                    Task {
//                        if shouldRefreshList {
//                            showProgressView = true
//                            fuelRecords = await fuelService.getFuelRecords()!
//                            showProgressView = false
//                            shouldRefreshList = false
//                        }
//                    }
                }
            }
        }
    }
}

#Preview {
    FuelRecordDetailsView(fuel: .constant(
        Fuel(
            id: "someID",
            userId: "someId",
            date: 1719923258485,
            vehicleId: "someId",
            litres: 23.45,
            amount: 1234.56,
            costPerLitre: 90.12,
            fuelType: "PETROL",
            paymentType: "CREDIT_CARD",
            vehicleCategoryId: "someId",
            createdAt: 1719923258485,
            updatedAt: 1719923258485,
            vehicle: Vehicle(
                id: "SomeID",
                name: "Skoda Kushaq",
                vehicleNumber: "KA09 MH1740",
                vehicleCategory: VehicleCategory(
                    id: "someID",
                    name: "Car"
                )
            )
        )
    )
    )
}
