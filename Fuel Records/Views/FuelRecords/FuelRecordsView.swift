//
//  FuelRecordsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordsView: View {
//    @Environment(HttpUtil.self) var httpUtil
//    @Binding var httpUtil: HttpUtil
    @State var fuelRecords: [Fuel]
    var fuelService = FuelService()
    @State var showAddFuelSheet: Bool = false
    @State var showProgressView = true
    @State var shouldRefreshList = false
    
    var body: some View {
        if showProgressView {
            ProgressView()
                .task {
                    fuelRecords = await fuelService.getFuelRecords()!
                    showProgressView = false
                    shouldRefreshList = false
                }
        } else {
            NavigationStack {
                List {
                    ForEach($fuelRecords) {
                        record in
                        FuelRecordRowView(fuel: record)
                    }.onDelete(perform: { indexSet in
                        fuelRecords.remove(atOffsets: indexSet)
                    })
                }
                .navigationTitle(Text("Fuel Logs"))
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
            .sheet(isPresented: $showAddFuelSheet,
                    onDismiss: {
                showAddFuelSheet = false
            }) {
                NavigationStack {
                    FuelRecordForm(shouldRefreshList: $shouldRefreshList, formType: "add")
                        .navigationTitle("Add Fuel Log")
                }
            }
            .task {
                if shouldRefreshList {
                    showProgressView = true
                    fuelRecords = await fuelService.getFuelRecords()!
                    showProgressView = false
                    shouldRefreshList = false
                }
            }
        }
    }
}

#Preview {
    FuelRecordsView(fuelRecords: [])
}
