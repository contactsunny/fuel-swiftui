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
            HStack {
                HStack{
                    Image(systemName: "car").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    Text(vehicleName!)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Spacer()
                VStack {
                    HStack {
                        Image(systemName: "calendar").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        Text("\(CustomUtil.getFormattedDateFromTimestamp(timestamp: $fuel.wrappedValue.date))")
                        Spacer()
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    HStack {
                        Image(systemName: "indianrupeesign").padding(EdgeInsets(top: 0, leading:5, bottom: 0, trailing: 6))
                        Text("\($fuel.wrappedValue.amount, specifier: "%.2f")")
                        Spacer()
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
