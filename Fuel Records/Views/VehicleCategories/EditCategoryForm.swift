//
//  EditCategoryForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI

struct EditCategoryForm: View {
    @Environment(\.dismiss) private var dismiss
    
    //    Services
    let vehicleCategoryService = VehicleCategoryService()
    
    @State var showProgressView = true
    @State var showErrorAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    @State var alertMessage: String? = ""
    @State var showApiCallProgressView: Bool = false
    
    //    Form controls
    @State var name: String = ""
    
    @Binding var category: VehicleCategory
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    name = category.name
                    showProgressView = false
                }
        } else {
            ZStack {
                if showApiCallProgressView {
                    ProgressView().zIndex(1)
                }
                NavigationStack {
                    Form {
                        Section(header: Text("Name")) {
                            TextField("Required", text: $name)
                                .textInputAutocapitalization(.words)
                        }
                    }
                    .disabled(showApiCallProgressView)
                    .navigationTitle("Edit Vehicle Category")
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
                                    await updateVehicleCategory()
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
    
    func updateVehicleCategory() async {
        guard !name.isEmpty
        else {
            alertMessage = "Please fill in all fields"
            showErrorAlert = true
            return
        }
        
        let updatedCategory = VehicleCategoryRequest(
            id: self.category.id,
            userId: nil,
            name: name
        )
        category = await vehicleCategoryService.updateVehicleCategory(
            category: updatedCategory
        )!
        
        shouldDismissSheet = true
    }
}

#Preview {
    EditCategoryForm(
        category: .constant(
            VehicleCategory(
                id: "1",
                name: "Car"
            )
        )
    )
}
