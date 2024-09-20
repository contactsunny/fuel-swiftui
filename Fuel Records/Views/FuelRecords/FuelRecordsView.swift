//
//  FuelRecordsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordsView: View {
//    @Environment(HttpUtil.self) var httpUtil
    @Binding var httpUtil: HttpUtil
    @State var fuelRecords: [Fuel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($fuelRecords) {
                    record in
                    FuelRecordRowView(fuel: record)
                }
            }
        }
            .task {
                let data = await self.httpUtil.makeGetCall(endpoint: "fuel?startDate=20240619000000&endDate=20240918235959")
                let decoder = JSONDecoder()
//                                    var content = String(data: data!, encoding: .utf8)!
//                                    print("Data")
//                                    print(content)
                var fuelRecordsResponse: FuelRecordsApiResponse
                do {
                    fuelRecordsResponse = try decoder.decode(FuelRecordsApiResponse.self, from: data!)
                    fuelRecords = fuelRecordsResponse.data
//                    for fuelRecord in fuelRecords {
//                        print("Vehicle ID: \(fuelRecord.vehicleId)")
//                        print("Amount: \(fuelRecord.amount)")
//                    }
                } catch let error {
                    print(error)
                }
            }
    }
}

#Preview {
    FuelRecordsView(httpUtil: .constant(HttpUtil()), fuelRecords: [])
}
