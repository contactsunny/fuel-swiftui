//
//  EditFuelRecordForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct EditFuelRecordForm: View {
    
    @Environment(\.dismiss) private var dismiss
    
    //    Services
    let vehicleService = VehicleService()
    var fuelService = FuelService()
    
    //    Data
    @State var vehicles: [Vehicle] = []
    
    //    UI Controlling Variables
//    @Binding var shouldRefreshList: Bool
    @State var showProgressView = true
    @State var showErrorAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    @State var alertMessage: String?
    @State var showApiCallProgressView: Bool = false
    
    //    Form controls
    @State var amount: Double?
    @State var litres: Double?
    @State var fuelType = "PETROL"
    @State var paymentMethod = "CREDIT_CARD"
    @State private var date = Date.now
    @State var vehicle: String?
    var costPerLitre: Double? {
        guard amount != nil, litres != nil else { return nil }
        return (amount! / litres!)
    }
    
    @Binding var fuel: Fuel
    
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    vehicles = await vehicleService.getVehicles()!
//                    fuel.vehicle = vehicles.first?.id
                    showProgressView = false
                }
        } else {
            ZStack {
                if showApiCallProgressView {
                    ProgressView().zIndex(1)
                }
                NavigationStack {
                    Form {
                        Section {
                            Picker("Vehicle", selection: $vehicle) {
                                ForEach(vehicles) { vehicle in
                                    Text(vehicle.name).tag(vehicle.id)
                                }
                            }
                        }
                        Section(header: Text("Amount (INR)")) {
                            TextField("Required", value: $amount, format: .number)
                                .disableAutocorrection(true)
                                .keyboardType(.decimalPad)
                        }
                        Section(header: Text("Volume")) {
                            TextField("Required", value: $litres, format: .number)
                                .disableAutocorrection(true)
                                .keyboardType(.decimalPad)
                        }
                        Section(header: Text("Cost Per Unit Volume")) {
                            Text("\(costPerLitre ?? 0.0, specifier: "%.2f")")
                        }
                        Section(header: Text("Fuel Type")) {
                            Picker("Fuel Type", selection: $fuelType) {
                                Text("Petrol").tag("PETROL")
                                Text("Diesel").tag("DIESEL")
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        Section {
                            Picker("Payment Type", selection: $paymentMethod) {
                                Text("UPI").tag("UPI")
                                Text("Cash").tag("CASH")
                                Text("Credit Card").tag("CREDIT_CARD")
                                Text("Debit Card").tag("DEBIT_CARD")
                            }
                        }
                        Section {
                            DatePicker(
                                selection: $date,
                                displayedComponents: .date
                            ) {
                                Text("Date")
                            }
                        }
                    }
                }
                .disabled(showApiCallProgressView)
                .onAppear(perform: {
                    paymentMethod = fuel.paymentType
                    vehicle = fuel.vehicleId
                    amount = fuel.amount
                    litres = fuel.litres
                    fuelType = fuel.fuelType
                    date = Date(timeIntervalSince1970: fuel.date/1000)
                })
                .navigationTitle("Add Fuel Log")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton().onTapGesture { // on tap gesture calls dismissal
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                showApiCallProgressView = true
                                await saveFuelLog()
                                if shouldDismissSheet {
                                    showApiCallProgressView = false
                                    shouldDismissSheet = false
                                    dismiss()
                                }
                                showApiCallProgressView = false
                            }
                        }
                    }
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage!),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    func saveFuelLog() async {
        guard amount != nil, litres != nil, costPerLitre != nil,
              !amount!.isNaN, !amount!.isZero, !litres!.isNaN,
              !litres!.isZero, !costPerLitre!.isNaN,
              !costPerLitre!.isZero
        else {
            alertMessage = "Please fill in all fields"
            showErrorAlert = true
            return
        }
        
        let updatedFuel = FuelRequest(
            id: fuel.id,
            userId: fuel.userId,
            date: CustomUtil.getDateStringForApiCalls(date: date),
            fuelType: fuelType,
            litres: litres!,
            costPerLitre: costPerLitre!,
            paymentType: paymentMethod,
            amount: amount!,
            vehicleId: vehicle!
        )
        fuel = await fuelService.updateFuelRecord(fuel: updatedFuel)!
        for vehicle in vehicles {
            if vehicle.id == fuel.vehicleId {
                fuel.vehicle = vehicle
            }
        }
        
//        shouldRefreshList = true
        shouldDismissSheet = true
    }
}

#Preview {
    EditFuelRecordForm(fuel: .constant(Fuel(
        id: "someID",
        userId: "someId",
        date: 1719923258,
        vehicleId: "someId",
        litres: 23.45,
        amount: 1234.56,
        costPerLitre: 90.12,
        fuelType: "DIESEL",
        paymentType: "UPI",
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
    )))
}
