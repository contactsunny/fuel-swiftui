//
//  AddCategoryForm.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI

struct AddCategoryForm: View {
    @Environment(\.dismiss) private var dismiss
    
    //    Services
    let vehicleCategoryService = VehicleCategoryService()
    
    @Binding var shouldRefreshList: Bool
    @State var showProgressView = true
    @State var showErrorAlert: Bool = false
    @State var shouldDismissSheet: Bool = false
    @State var alertMessage: String? = ""
    @State var showApiCallProgressView: Bool = false
    
    //    Form controls
    @State var name: String = ""
    
    var body: some View {
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
                .navigationTitle("Add Vehicle Category")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton().onTapGesture { // on tap gesture calls dismissal
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            Task {
                                showApiCallProgressView = true
                                await saveVehicleCategory()
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
    
    func saveVehicleCategory() async {
        guard !name.isEmpty
        else {
            alertMessage = "Please fill in all fields"
            showErrorAlert = true
            return
        }
        
        let category = VehicleCategoryRequest(
            id: nil,
            userId: nil,
            name: name
        )
        let _ = await vehicleCategoryService.saveVehicleCategory(
            category: category
        )
        
        shouldRefreshList = true
        shouldDismissSheet = true
    }
}

#Preview {
    AddCategoryForm(shouldRefreshList: .constant(false))
}
