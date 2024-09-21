//
//  VehicleRowView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct VehicleRowView: View {
    
    @Binding var vehicle: Vehicle
    
    var body: some View {
        NavigationLink(destination: VehicleDetailsView(vehicle: $vehicle)) {
            Section {
                VStack {
                    HStack {
                        Text(vehicle.name)
                            .font(.headline)
                            .textScale(.default)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    HStack {
                        Text(vehicle.vehicleNumber)
                            .font(.subheadline)
                            .textScale(.default)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    HStack {
                        Text(vehicle.vehicleCategory?.name ?? "")
                            .font(.subheadline)
                            .textScale(.default)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    VehicleRowView(
        vehicle: .constant(
            Vehicle(
                id: "someID",
                name: "Vehicle Name",
                vehicleNumber: "KA09 MH1740",
                vehicleCategory: VehicleCategory(
                    id: "someID",
                    name: "Car"
                )
            )
        )
    )
}
