//
//  VehicleCategoryRowView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 22/09/24.
//

import SwiftUI

struct VehicleCategoryRowView: View {
    
    @Binding var category: VehicleCategory
    
    var body: some View {
        NavigationLink(destination: VehicleCategoryDetailsView(category: $category)) {
            Section {
                VStack {
                    HStack {
                        Text(category.name)
                            .font(.headline)
                            .textScale(.default)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
//                    HStack {
//                        Text(vehicle.vehicleNumber)
//                            .font(.subheadline)
//                            .textScale(.default)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
//                    
//                    HStack {
//                        Text(vehicle.vehicleCategory?.name ?? "")
//                            .font(.subheadline)
//                            .textScale(.default)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
                }
            }
        }
    }
}

#Preview {
    VehicleCategoryRowView(
        category: .constant(
            VehicleCategory(
                id: "someID",
                name: "Car"
            )
        )
    )
}
