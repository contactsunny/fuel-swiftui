//
//  SettingsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    let year = String(Calendar.current.component(.year, from: Date()))
    @State var showApiCallProgressView: Bool = false
    
    let vehicleService = VehicleService()
    let preferencesService = PreferencesService()
    
    @State var vehicles: [Vehicle] = []
    @State var localPreferences: Preferences?
    @State var defaultVehicleId: String?
    @State var defaultFuelType: String?
    @State var defaultPaymentType: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                if showApiCallProgressView {
                    ProgressView().zIndex(1)
                }
                List {
                    Section(header: Text("Vehicles & More")) {
                        NavigationLink(destination: VehiclesListView()) {
                            Text("Vehicles")
                        }
                        NavigationLink(destination: VehicleCategoryListView()) {
                            Text("Vehicle Categories")
                        }
                    }
                    
                    Section(header: Text("Defaults")) {
                        Picker("Vehicle", selection: $defaultVehicleId) {
                            ForEach(vehicles) { vehicle in
                                Text(vehicle.name).tag(vehicle.id)
                            }
                        }
                        
                        Picker("Fuel Type", selection: $defaultFuelType) {
                            Text("Petrol").tag("PETROL")
                            Text("Diesel").tag("DIESEL")
                            Text("CNG").tag("CNG")
                            Text("EV").tag("EV")
                        }
                        
                        Picker("Payment Method", selection: $defaultPaymentType) {
                            Text("Credit Card").tag("CREDIT_CARD")
                            Text("Debit Card").tag("DEBIT_CARD")
                            Text("Cash").tag("CASH")
                            Text("UPI").tag("UPI")
                        }
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            VStack {
                                Text("About")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("© \(year)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("[Sunny Srinidhi](https://blog.contactsunny.com)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .navigationTitle(Text("Settings"))
                .onChange(of: defaultVehicleId) {
                    Task {
                        savePreferences()
                    }
                }
                .onChange(of: defaultFuelType) {
                    Task {
                        savePreferences()
                    }
                }
                .onChange(of: defaultPaymentType) {
                    Task {
                        savePreferences()
                    }
                }
            }
            .task {
                Task {
                    showApiCallProgressView = true
                    await refreshList()
                    showApiCallProgressView = false
                }
            }
        }
    }
    
    func savePreferences() {
        showApiCallProgressView = true
        Task {
            localPreferences?.defaultVehicleId = defaultVehicleId
            localPreferences?.defaultFuelType = defaultFuelType
            localPreferences?.defaultPaymentType = defaultPaymentType
            
            localPreferences = await preferencesService.savePreferences(
                preferences: localPreferences!
            )
            
            if let encoded = try? JSONEncoder().encode(localPreferences) {
                UserDefaults.standard.set(encoded, forKey: "preferences")
            }
        }
        showApiCallProgressView = false
    }
    
    func refreshList() async {
        showApiCallProgressView = true
        Task {
            vehicles = await vehicleService.getVehicles()!
            
            localPreferences = LocalStorageUtil.getPreferencesFromLocalStorage()
            
            if self.localPreferences == nil {
                self.defaultVehicleId = vehicles.first?.id
                self.defaultFuelType = "PETROL"
                self.defaultPaymentType = "CREDIT_CARD"
            } else {
                self.defaultVehicleId = localPreferences?.defaultVehicleId
                self.defaultFuelType = localPreferences?.defaultFuelType ?? "PETROL"
                self.defaultPaymentType = localPreferences?.defaultPaymentType ?? "CREDIT_CARD"
            }
        }
        showApiCallProgressView = false
    }
    
    
}

#Preview {
    SettingsView()
}
