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
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
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
            .disabled(showProgressView)
            .task {
                fuelRecords = await fuelService.getFuelRecords()!
                showProgressView = false
                shouldRefreshList = false
            }
            .refreshable {
                Task {
                    fuelRecords = await fuelService.getFuelRecords()!
                }
            }
            .sheet(isPresented: $showAddFuelSheet,
                   onDismiss: {
                showAddFuelSheet = false
            }) {
                NavigationStack {
                    FuelRecordForm(shouldRefreshList: $shouldRefreshList)
                        .navigationTitle("Add Fuel Log")
                }.onDisappear() {
                    Task {
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
    }
}

#Preview {
    FuelRecordsView(fuelRecords: [])
}
