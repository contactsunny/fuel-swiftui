//
//  VehicleCategoryListView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehicleCategoryListView: View {
    @State var vehicleCategories: [VehicleCategory] = []
    @State var showAddVehicleCategorySheet: Bool = false
    @State var showProgressView = true
    @State var shouldRefreshList = false
    @State var showDeleteAlert: Bool = false
    @State var searchTerm = ""
    @State var categoryFilter: String = "all"
    
    @State var deleteIndexSet: IndexSet = []
    
    var vehicleCategoryService = VehicleCategoryService()
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            List {
                ForEach($vehicleCategories) {
                    category in
                    if searchTerm.isEmpty || category.wrappedValue.name.lowercased().contains(searchTerm.lowercased()) {
                        VehicleCategoryRowView(category: category)
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
                        showAddVehicleCategorySheet = true
                    }
                }
            }
            .navigationTitle(Text("Vehicle Categories"))
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
            .sheet(isPresented: $showAddVehicleCategorySheet,
                   onDismiss: {
                showAddVehicleCategorySheet = false
            }) {
                NavigationStack {
                    AddCategoryForm(shouldRefreshList: $shouldRefreshList)
                        .navigationTitle("Add Vehicle Category")
                }.onDisappear() {
                    Task {
                        if shouldRefreshList {
                            await refreshList()
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
            vehicleCategories = await vehicleCategoryService.getVehicleCategories()!
            showProgressView = false
        }
    }
    
    func delete() async {
        Task {
            for index in self.deleteIndexSet {
                let category = vehicleCategories[index]
                print("Deleteing \(category.id) \(category.name)")
                await vehicleCategoryService.deleteVehicleCategory(id: category.id)
                await refreshList()
            }
        }
    }
}

#Preview {
    VehicleCategoryListView()
}
