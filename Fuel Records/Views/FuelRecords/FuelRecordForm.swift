//
//  FuelRecordForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordForm: View {
    
    @Binding var shouldRefreshList: Bool
    let formType: String
    @State var amount: Double?
    @State var litres: Double?
    @State var fuelType = "PETROL"
    @State var paymentMethod = "CREDIT_CARD"
    @State private var date = Date.now
    var costPerLitre: Double? {
        guard amount != nil, litres != nil else { return nil }
        return (amount! / litres!)
    }
    @State var vehicles: [Vehicle] = []
    @State var vehicle: String?
    let vehicleService = VehicleService()
    var fuelService = FuelService()
    @State var showProgressView = true
    @Environment(\.dismiss) private var dismiss
    @State var showErrorAlert: Bool = false
    @State var alertMessage: String?
//    @State var showSuccessAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    vehicles = await vehicleService.getVehicles()!
                    vehicle = vehicles.first?.id
                    showProgressView = false
                }
        } else {
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
            .navigationTitle(formType == "add" ? "Add Fuel Log" : "Edit Fuel Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton().onTapGesture { // on tap gesture calls dismissal
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveFuelLog()
                            if shouldDismissSheet {
                                shouldDismissSheet = false
                                dismiss()
                            }
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
        
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        /// "2020-05-28 00:20:00 GMT+5:30"
        var stringDate = dtf.string(from: Date.now)
        stringDate = stringDate.replacingOccurrences(of: " ", with: "T")
        stringDate = stringDate + "Z"
        
        let fuel = FuelRequest(
            date: stringDate,
            fuelType: fuelType,
            litres: litres!,
            costPerLitre: costPerLitre!,
            paymentType: paymentMethod,
            amount: amount!,
            vehicleId: vehicle!
        )
        let result = await fuelService.postFuelRecord(fuel: fuel)
        print(result!.id)
        shouldRefreshList = true
//        showSuccessAlert = true
        shouldDismissSheet = true
    }
}

#Preview {
    FuelRecordForm(shouldRefreshList: .constant(false), formType: "add")
}
