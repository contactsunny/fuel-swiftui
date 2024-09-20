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
    var fuelService = FuelService()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($fuelRecords) {
                    record in
//                    Section {
                        FuelRecordRowView(fuel: record)
//                    }
                }
            }.navigationTitle(Text("Fuel Logs"))
        }
        .task {
            fuelRecords = await fuelService.getFuelRecords()!
        }
    }
}

#Preview {
    FuelRecordsView(httpUtil: .constant(HttpUtil()), fuelRecords: [])
}
