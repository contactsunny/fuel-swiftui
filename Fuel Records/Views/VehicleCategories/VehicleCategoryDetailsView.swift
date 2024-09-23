//
//  VehicleCategoryDetailsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 22/09/24.
//

import SwiftUI

struct VehicleCategoryDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var category: VehicleCategory
    @State var showEdit: Bool = false
    @State var shouldShowDeleteAlert: Bool = false
    @State var showEditVehicleSheet: Bool = false
    @State var showProgressView = false
    
    //    Services
    let vehicleCategoryService = VehicleCategoryService()
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            VStack {
                List {
                    Section(header: Text("Vehicle Category Info")) {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text("\(category.name)")
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
                                Button {
                                    showEditVehicleSheet = true
                                } label: {
                                    Image(systemName: "pencil")
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
                                EditCategoryForm(category: $category)
                                    .navigationTitle("Edit Vehicle Category")
                            }.onDisappear() {
                            }
                        }
                    }
                }
            }
        }
    }
    
    func delete() async {
        Task {
            showProgressView = true
            print("Deleteing \(category.id) \(category.name)")
            await vehicleCategoryService.deleteVehicleCategory(id: category.id)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    VehicleCategoryDetailsView(
        category: .constant(
            VehicleCategory(
                id: "someID",
                name: "Car"
            )
        )
    )
}
