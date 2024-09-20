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
    @State var showAddFuelSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($fuelRecords) {
                    record in
                    FuelRecordRowView(fuel: record)
                }.onDelete(perform: { indexSet in
                    fuelRecords.remove(atOffsets: indexSet)
                })
            }.navigationTitle(Text("Fuel Logs"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            showAddFuelSheet = true
                        }
                    }
                }
        }
        .task {
            fuelRecords = await fuelService.getFuelRecords()!
        }.sheet(isPresented: $showAddFuelSheet,
                onDismiss: {
            showAddFuelSheet = false
        }) {
            NavigationStack {
                Form {
                }
                .navigationTitle("Add Fuel Log")
            }
        }
    }
}

#Preview {
    FuelRecordsView(httpUtil: .constant(HttpUtil()), fuelRecords: [])
}
