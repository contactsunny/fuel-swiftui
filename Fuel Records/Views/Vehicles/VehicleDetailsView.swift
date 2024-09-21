//
//  VehicleDetailsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehicleDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var vehicle: Vehicle
    @State var showEdit: Bool = false
    @State var shouldShowDeleteAlert: Bool = false
    @State var showEditVehicleSheet: Bool = false
    @State var showProgressView = false
    
    var vehicleService = VehicleService()
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
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
                                Task  {
                                    await delete()
                                }
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
            .disabled(showProgressView)
        }
    }
    
    func delete() async {
        Task {
            showProgressView = true
            print("Deleteing \(vehicle.id) \(vehicle.name)")
            await vehicleService.deleteVehicle(id: vehicle.id)
            self.presentationMode.wrappedValue.dismiss()
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
