//
//  FuelRecordForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordForm: View {
    
    @Environment(\.dismiss) private var dismiss
    
//    Services
    let vehicleService = VehicleService()
    var fuelService = FuelService()
    
//    Data
    @State var vehicles: [Vehicle] = []
    
//    UI Controlling Variables
    @Binding var shouldRefreshList: Bool
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
    
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    vehicles = await vehicleService.getVehicles()!
                    vehicle = vehicles.first?.id
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
                            DatePicker(selection: $date, displayedComponents: .date) {
                                Text("Date")
                            }
                        }
                    }
                }
                .disabled(showApiCallProgressView)
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
        
        let fuel = FuelRequest(
            id: nil,
            userId: nil,
            date: CustomUtil.getDateStringForApiCalls(date: date),
            fuelType: fuelType,
            litres: litres!,
            costPerLitre: costPerLitre!,
            paymentType: paymentMethod,
            amount: amount!,
            vehicleId: vehicle!
        )
        let _ = await fuelService.saveFuelRecord(fuel: fuel)
        
        shouldRefreshList = true
        shouldDismissSheet = true
    }
}

#Preview {
    FuelRecordForm(shouldRefreshList: .constant(false))
}
