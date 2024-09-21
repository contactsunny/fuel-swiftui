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
    @State var showDeleteAlert: Bool = false
    
    @State var totalFuelVolume: Double = 0.0
    @State var totalFuelCost: Double = 0.0
    @State var deleteIndexSet: IndexSet = []
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            NavigationStack {
                List {
                    Section(header: Text("Quick Analytics")) {
                        HStack {
                            Text("Total Spend")
                            Spacer()
                            Text("Rs. \(totalFuelCost, specifier: "%.2f")")
                        }
                        HStack {
                            Text("Total Fuel Volume")
                            Spacer()
                            Text("\(totalFuelVolume, specifier: "%.2f") L")
                        }
                    }
                    ForEach($fuelRecords) {
                        record in
                        FuelRecordRowView(fuel: record)
                    }
                    .onDelete(perform: { indexSet in
                        deleteIndexSet = indexSet
                        showDeleteAlert = true
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
                
                for record in fuelRecords {
                    totalFuelCost = totalFuelCost + record.amount
                    totalFuelVolume = totalFuelVolume + record.litres
                }
                
                showProgressView = false
                shouldRefreshList = false
            }
            .refreshable {
                Task {
                    showProgressView = true
                    fuelRecords = await fuelService.getFuelRecords()!
                    showProgressView = false
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
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Are you sure?"),
                      primaryButton: .cancel(),
                      secondaryButton: .destructive(Text("Yes"),
                    action: {
                        Task  {
                            await delete()
                        }
                }))
            }
        }
    }
    
    func delete() async {
        Task {
            for index in self.deleteIndexSet {
                let fuel = fuelRecords[index]
                print("Deleteing \(fuel.id) \(fuel.amount)")
                await fuelService.deleteFuelRecord(id: fuel.id)
                showProgressView = true
                fuelRecords = await fuelService.getFuelRecords()!
                showProgressView = false
            }
        }
    }
}

#Preview {
    FuelRecordsView(fuelRecords: [])
}
