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
        NavigationLink(destination: FuelRecordDetailsView()) {
            VStack {
                HStack{
                    Text("Vehicle")
                    Spacer()
                    Text("\($fuel.wrappedValue.vehicleId)")
                }
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("Rs. \($fuel.wrappedValue.amount, specifier: "%.2f")")
                }
                HStack {
                    Text("Litres")
                    Spacer()
                    Text("\($fuel.wrappedValue.litres)")
                }
                
                //            HStack {
//                Text("\($fuel.wrappedValue.vehicleId)").frame(maxWidth: .infinity)
//                Text("Rs. \($fuel.wrappedValue.amount, specifier: "%.2f")").frame(maxWidth: .infinity)
//                //            }
//                //            HStack {
//                Text("\($fuel.wrappedValue.vehicleId)").frame(maxWidth: .infinity)
//                Text("\($fuel.wrappedValue.amount, specifier: "%.2f")").frame(maxWidth: .infinity)
                //            }
                
            }
        }
    }
}

#Preview {
    FuelRecordRowView(fuel: .constant(Fuel(id: "someID", userId: "someId", date: Date().localDate(), vehicleId: "someId", litres: 23.45, amount: 1234.56, costPerLitre: 90.12, fuelType: "PETROL", paymentType: "UPI", vehicleCategoryId: "someId", createdAt: Date().localDate(), updatedAt: Date().localDate())))
}
