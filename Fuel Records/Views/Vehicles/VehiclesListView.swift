//
//  VehiclesListView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehiclesListView: View {
    
    @State var vehicles: [Vehicle] = []
    @State var showProgressView = true
    @State var shouldRefreshList = false
    @State var showAddVehicleSheet = false
    @State var showDeleteAlert: Bool = false
    
    @State var searchTerm = ""
    @State var categoryFilter: String = "all"
    @State var vehicleCategories: [VehicleCategory] = []
    
    @State var deleteIndexSet: IndexSet = []
    
    var vehicleService = VehicleService()
    
    var body: some View {
        
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            List {
                Section {
                    Picker("Category", selection: $categoryFilter) {
                        Text("All").tag("all")
                        ForEach(vehicleCategories) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                }
                ForEach($vehicles) {
                    vehicle in
                    if searchTerm.isEmpty ||
                        vehicle.wrappedValue.name.lowercased().contains(searchTerm.lowercased()) ||
                        vehicle.wrappedValue.vehicleNumber.lowercased().contains(searchTerm.lowercased()) {
                        if (categoryFilter != "all" &&
                            vehicle.wrappedValue.vehicleCategoryId.lowercased() == categoryFilter.lowercased()) || categoryFilter == "all"
                        {
                        VehicleRowView(vehicle: vehicle)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteIndexSet = indexSet
                    showDeleteAlert = true
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
//            .disabled(showProgressView)
            .task {
                await refreshList()
                shouldRefreshList = false
            }
            .refreshable {
                Task {
                    await refreshList()
                }
            }
            .searchable(text: $searchTerm) {
                
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
                            await refreshList()
                            shouldRefreshList = false
                        }
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Are you sure?"),
                      primaryButton: .cancel(),
                      secondaryButton: .destructive(Text("Yes"),
                                                    action: {
                    Task  {
                        await delete()
                    }
                }))
            }
        }
    }
    
    func refreshList() async {
        Task {
            showProgressView = true
            vehicles = await vehicleService.getVehicles()!
            vehicleCategories = []
            for vehicle in vehicles {
                if !vehicleCategories.contains(where: { $0.id == vehicle.vehicleCategory!.id }) {
                    vehicleCategories.append(vehicle.vehicleCategory!)
                }
            }
            showProgressView = false
        }
    }
    
    func delete() async {
        Task {
            for index in self.deleteIndexSet {
                let vehicle = vehicles[index]
                await vehicleService.deleteVehicle(id: vehicle.id)
                showProgressView = true
                vehicles = await vehicleService.getVehicles()!
                showProgressView = false
            }
        }
    }
}

#Preview {
    VehiclesListView()
}
