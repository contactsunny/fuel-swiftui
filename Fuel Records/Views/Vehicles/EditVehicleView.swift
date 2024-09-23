//
//  EditVehicleView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct EditVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    
    //    Services
    let vehicleService = VehicleService()
    let vehicleCategoryService = VehicleCategoryService()
    
    //    Data
    @State var vehicleCategories: [VehicleCategory] = []
    
    //    UI Controlling Variables
    @State var showProgressView = true
    @State var showErrorAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    @State var alertMessage: String? = ""
    @State var showApiCallProgressView: Bool = false
    
    //    Form controls
    @State var name: String = ""
    @State var registrationNumber: String = ""
    @State var vehicleCategoryId: String = ""
    
    @Binding var vehicle: Vehicle
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    vehicleCategories = await vehicleCategoryService.getVehicleCategories()!
                    vehicleCategories.append(VehicleCategory(id: "unknown", name: "Unknown"))
                    vehicleCategoryId = vehicle.vehicleCategoryId
                    name = vehicle.name
                    registrationNumber = vehicle.vehicleNumber
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
                            Picker("Vehicle Category", selection: $vehicleCategoryId) {
                                ForEach(vehicleCategories) { category in
                                    Text(category.name).tag(category.id)
                                }
                            }
                        }
                        Section(header: Text("Name")) {
                            TextField("Required", text: $name)
                                .textInputAutocapitalization(.words)
                        }
                        Section(header: Text("Registration Number")) {
                            TextField("Required", text: $registrationNumber)
                                .textInputAutocapitalization(.characters)
                        }
                    }
                    .disabled(showApiCallProgressView)
                    .navigationTitle("Update Vehicle")
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
                                    await updateVehicle()
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
    }
    
    func updateVehicle() async {
        guard !name.isEmpty, !registrationNumber.isEmpty
        else {
            alertMessage = "Please fill in all fields"
            showErrorAlert = true
            return
        }
        
        guard vehicleCategoryId != "unknown"
        else {
            alertMessage = "Please select a valid vehicle category"
            showErrorAlert = true
            return
        }
        
        let vehicleRequest = VehicleRequest(
            id: vehicle.id,
            userId: nil,
            name: name,
            vehicleNumber: registrationNumber,
            vehicleCategoryId: vehicleCategoryId
        )
        vehicle = await vehicleService.updateVehicle(vehicle: vehicleRequest)!
        
        for vehicleCategory in vehicleCategories {
            if vehicle.vehicleCategoryId == vehicleCategory.id {
                vehicle.vehicleCategory = vehicleCategory
            }
        }
        
        shouldDismissSheet = true
    }
}

#Preview {
    EditVehicleView(
        vehicle: .constant(
            Vehicle(
                id: "someID",
                name: "Vehicle Name",
                vehicleNumber: "KA09 MH1740",
                vehicleCategory: VehicleCategory(
                    id: "someID",
                    name: "Car"
                )
            )
        )
    )
}
