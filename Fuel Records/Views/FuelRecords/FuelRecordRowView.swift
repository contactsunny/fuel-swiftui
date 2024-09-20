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
            VStack {
                HStack{
                    Text("Vehicle")
                    Spacer()
                    Text(vehicleName!)
                }
                HStack {
                    Text("Date")
                    Spacer()
                    Text("\(CustomUtil.getFormattedDateFromTimestamp(timestamp: $fuel.wrappedValue.date))")
                }
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("Rs. \($fuel.wrappedValue.amount, specifier: "%.2f")")
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
    FuelRecordRowView(fuel: .constant(Fuel(id: "someID", userId: "someId", date: 1726819273, vehicleId: "someId", litres: 23.45, amount: 1234.56, costPerLitre: 90.12, fuelType: "PETROL", paymentType: "UPI", vehicleCategoryId: "someId", createdAt: 1726819273, updatedAt: 1726819273)))
}
