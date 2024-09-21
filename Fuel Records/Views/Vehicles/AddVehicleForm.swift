//
//  AddVehicleForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct AddVehicleForm: View {
    @Environment(\.dismiss) private var dismiss
    
    //    Services
    let vehicleService = VehicleService()
    let vehicleCategoryService = VehicleCategoryService()
    
    //    Data
    @State var vehicleCategories: [VehicleCategory] = []
    
    //    UI Controlling Variables
    @Binding var shouldRefreshList: Bool
    @State var showProgressView = true
    @State var showErrorAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    @State var alertMessage: String? = ""
    @State var showApiCallProgressView: Bool = false

    //    Form controls
    @State var name: String = ""
    @State var registrationNumber: String = ""
    @State var vehicleCategoryId: String = ""

    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    vehicleCategories = await vehicleCategoryService.getVehicleCategories()!
                    vehicleCategoryId = vehicleCategories.first!.id
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
                    .navigationTitle("Add Vehicle")
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
                                    await saveVehicle()
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
    
    func saveVehicle() async {
        guard !name.isEmpty, !registrationNumber.isEmpty
        else {
            alertMessage = "Please fill in all fields"
            showErrorAlert = true
            return
        }
        
        let vehicleRequest = VehicleRequest(
            id: nil,
            userId: nil,
            name: name,
            vehicleNumber: registrationNumber,
            vehicleCategoryId: vehicleCategoryId
        )
        let _ = await vehicleService.saveVehicle(vehicle: vehicleRequest)
        
        shouldRefreshList = true
        shouldDismissSheet = true
    }
}

#Preview {
    AddVehicleForm(shouldRefreshList: .constant(false))
}
