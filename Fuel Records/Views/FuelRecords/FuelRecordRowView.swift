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
        VStack {
            HStack {
                Text("\($fuel.wrappedValue.vehicleId)")
                Text("Rs. \($fuel.wrappedValue.amount, specifier: "%.2f")")
            }
            HStack {
                Text("\($fuel.wrappedValue.vehicleId)")
                Text("\($fuel.wrappedValue.amount, specifier: "%.2f")")
            }
            
        }
    }
}

#Preview {
    FuelRecordRowView(fuel: .constant(Fuel(id: "someID", userId: "someId", date: Date().localDate(), vehicleId: "someId", litres: 23.45, amount: 1234.56, costPerLitre: 90.12, fuelType: "PETROL", paymentType: "UPI", vehicleCategoryId: "someId", createdAt: Date().localDate(), updatedAt: Date().localDate())))
}
