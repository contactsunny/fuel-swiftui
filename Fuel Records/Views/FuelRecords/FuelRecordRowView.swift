//
//  FuelRecordRowView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordRowView: View {
    @Binding var fuel: Fuel
    var body: some View {
        let vehicleName = ($fuel.wrappedValue.vehicle != nil) ? $fuel.wrappedValue.vehicle?.name : "Not available"
        
        NavigationLink(destination: FuelRecordDetailsView(fuel: $fuel)) {
            Section {
                VStack {
                    VStack(spacing: 3) {
                        HStack {
                            Text(vehicleName!)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .textScale(.default)
                                .foregroundColor(.primary)
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("\(CustomUtil.getFormattedDateFromTimestamp(timestamp: $fuel.wrappedValue.date))")
                                .foregroundColor(.secondary)
                                .textScale(.secondary)
                            Spacer()
                        }
                        HStack {
                            Text("Rs. \($fuel.wrappedValue.amount, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                                .textScale(.secondary)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FuelRecordRowView(fuel: .constant(
        Fuel(
            id: "someID",
            userId: "someId",
            date: 1719923258485,
            vehicleId: "someId",
            litres: 23.45,
            amount: 1234.56,
            costPerLitre: 90.12,
            fuelType: "PETROL",
            paymentType: "UPI",
            vehicleCategoryId: "someId",
            createdAt: 1719923258485,
            updatedAt: 1719923258485,
            vehicle: Vehicle(
                id: "SomeID",
                name: "Skoda Kushaq",
                vehicleNumber: "KA09 MH1740",
                vehicleCategory: VehicleCategory(
                    id: "someID",
                    name: "Car"
                )
            )
        )
        )
    )
}
