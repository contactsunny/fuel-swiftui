//
//  VehiclesListView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehiclesListView: View {
    
    @State var vehicles: [Vehicle] = []
    @State var showAddFuelSheet: Bool = false
    @State var showProgressView = true
    @State var shouldRefreshList = false
    @State var showAddVehicleSheet = false
    
    var vehicleService = VehicleService()
    
    var body: some View {
        
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            List {
                ForEach($vehicles) {
                    vehicle in
                    VehicleRowView(vehicle: vehicle)
                }.onDelete(perform: { indexSet in
                    vehicles.remove(atOffsets: indexSet)
                })
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showAddVehicleSheet = true
                    }
                }
            }
            .navigationTitle(Text("Vehicles"))
            .disabled(showProgressView)
            .task {
                showProgressView = true
                vehicles = await vehicleService.getVehicles()!
                showProgressView = false
                shouldRefreshList = false
            }
            .refreshable {
                Task {
                    showProgressView = true
                    vehicles = await vehicleService.getVehicles()!
                    showProgressView = false
                }
            }
            .sheet(isPresented: $showAddVehicleSheet,
                   onDismiss: {
                showAddVehicleSheet = false
            }) {
                NavigationStack {
                    AddVehicleForm(shouldRefreshList: $shouldRefreshList)
                        .navigationTitle("Add Vehicle")
                }.onDisappear() {
                    Task {
                        if shouldRefreshList {
                            showProgressView = true
                            vehicles = await vehicleService.getVehicles()!
                            showProgressView = false
                            shouldRefreshList = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VehiclesListView()
}
