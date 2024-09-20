//
//  FuelRecordDetailsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordDetailsView: View {
    
    @Binding var fuel: Fuel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FuelRecordDetailsView(fuel: .constant(Fuel(id: "someID", userId: "someId", date: 1726819273, vehicleId: "someId", litres: 23.45, amount: 1234.56, costPerLitre: 90.12, fuelType: "PETROL", paymentType: "UPI", vehicleCategoryId: "someId", createdAt: 1726819273, updatedAt: 1726819273)))
}
