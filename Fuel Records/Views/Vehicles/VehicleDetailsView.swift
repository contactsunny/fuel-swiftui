//
//  VehicleDetailsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehicleDetailsView: View {
    @Binding var vehicle: Vehicle
    @State var showEdit: Bool = false
    @State var shouldShowDeleteAlert: Bool = false
    @State var showEditVehicleSheet: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Vehicle Info")) {
                    HStack {
                        Text("Vehicle")
                        Spacer()
                        Text("\(vehicle.name)")
                    }
                    HStack {
                        Text("Registration Number")
                        Spacer()
                        Text("\(vehicle.vehicleNumber)")
                    }
                    HStack {
                        Text("Category")
                        Spacer()
                        Text("\(vehicle.vehicleCategory!.name)")
                    }
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
                                showEditVehicleSheet = true
                            }
                        }
                    }
                    .alert(isPresented: $shouldShowDeleteAlert) {
                        Alert(title: Text("Are you sure?"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Yes"), action: {
                            
                        }))
                    }
                    .sheet(isPresented: $showEditVehicleSheet, onDismiss: {
                        showEditVehicleSheet = false
                    }) {
                        NavigationStack {
                            EditVehicleView(vehicle: $vehicle)
                                .navigationTitle("Edit Vehicle")
                        }.onDisappear() {
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VehicleDetailsView(vehicle: .constant(
        Vehicle(
            id: "someID",
            name: "Vehicle Name",
            vehicleNumber: "KA09 MH1740",
            vehicleCategory: VehicleCategory(
                id: "someID",
                name: "Car"
            )
        )
    ))
}
