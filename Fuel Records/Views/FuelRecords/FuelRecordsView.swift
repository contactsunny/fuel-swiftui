//
//  FuelRecordsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct FuelRecordsView: View {
//    @Environment(HttpUtil.self) var httpUtil
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var orientation = UIDevice.current.orientation
    
    @State var fuelRecords: [Fuel]
    @State var filteredRecords: [Fuel] = []
    var fuelService = FuelService()
    @State var showAddFuelSheet: Bool = false
    @State var showProgressView = false
    @State var shouldRefreshList = false
    @State var showDeleteAlert: Bool = false
    
    @State var totalFuelVolume: Double = 0.0
    @State var totalFuelCost: Double = 0.0
    @State var deleteIndexSet: IndexSet = []
    
    @State var vehicles: [Vehicle] = []
    @State var vehicleCategories: [VehicleCategory] = []
    @State var fuelTypes: [String] = []
    @State var paymentMethods: [String] = []
    
//    Filter vars
    @State var showFilterSection: Bool = false
    @State var filterCriteria = FuelFilterCriteria()
    
    
    var body: some View {
        ZStack {
            if showProgressView {
                ProgressView().zIndex(1)
            }
            VStack {
                if (orientation == .landscapeLeft || orientation == .landscapeRight) && horizontalSizeClass == .regular {
                    NavigationView {
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
                            ForEach($filteredRecords) {
                                record in
                                FuelRecordRowView(fuel: record, shouldRefreshList: $shouldRefreshList)
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
                } else {
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
                            ForEach($filteredRecords) {
                                record in
//                                if recordInFilter(record: record.wrappedValue)
//                                {
                                FuelRecordRowView(fuel: record, shouldRefreshList: $shouldRefreshList)
//                                }
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
                                Button {
                                    showFilterSection.toggle()
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showAddFuelSheet = true
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                }
            }
//            .disabled(showProgressView)
            .task {
                await refreshList()
                shouldRefreshList = false
            }
            .refreshable {
                Task {
                    await refreshList()
                }
            }
            .sheet(isPresented: $showAddFuelSheet,
                   onDismiss: {
                showAddFuelSheet = false
            }) {
                NavigationStack {
                    FuelRecordForm(shouldRefreshList: $shouldRefreshList)
                        .navigationTitle("Add Fuel Log")
                }
            }
            .sheet(isPresented: $showFilterSection,
                   onDismiss: {
                showFilterSection = false
            }) {
                NavigationStack {
                    FuelListFilterView(
                        shouldRefreshList: .constant(true),
                        showFilterSection: $showFilterSection,
                        vehicles: $vehicles,
                        vehicleCategories: $vehicleCategories,
                        fuelTypes: $fuelTypes,
                        paymentMethods: $paymentMethods,
                        criteria: $filterCriteria
                    ).navigationTitle("Filter Fuel Logs")
                }.onDisappear() {
                    Task {
                        print("On Disappear")
                        await refreshList()
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
            .onChange(of: shouldRefreshList) {
                Task {
                    await refreshList()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
                print("Orientation changed: \(orientation)")
            }
            .environment(\.horizontalSizeClass, orientation == .portrait ? .compact : .regular)
        }
    }
    
    func recordInFilter(record: Fuel) -> Bool {
        var shouldShow = false
        if filterCriteria.vehicleId == "all" || record.vehicleId.lowercased() == filterCriteria.vehicleId.lowercased() {
            if Date(timeIntervalSince1970: record.date/1000) >= filterCriteria.startDate && Date(timeIntervalSince1970: record.date/1000) <= filterCriteria.endDate {
                if filterCriteria.vehicleCategoryId == "all" || record.vehicle?.vehicleCategoryId.lowercased() == filterCriteria.vehicleCategoryId.lowercased() {
                    if filterCriteria.fuelType == "all" || filterCriteria.fuelType.lowercased() == record.fuelType.lowercased() {
                        if filterCriteria.paymentType == "all" || filterCriteria.paymentType.lowercased() == record.paymentType.lowercased() {
                            shouldShow = true
                        }
                    }
                }
            }
        }
        
        return shouldShow
    }
    
    func refreshList() async {
        Task {
            showProgressView = true
            fuelRecords = await fuelService.getFuelRecords(
                fromDate: filterCriteria.startDate, toDate: filterCriteria.endDate
            )!
            
            totalFuelCost = 0.0
            totalFuelVolume = 0.0
            vehicles = []
            vehicleCategories = []
            filteredRecords = []
            
            for record in fuelRecords {
                if recordInFilter(record: record) {
                    filteredRecords.append(record)
                    totalFuelCost = totalFuelCost + record.amount
                    totalFuelVolume = totalFuelVolume + record.litres
                }
                
                if !fuelTypes.contains(record.fuelType) {
                    fuelTypes.append(record.fuelType)
                }
                
                if !paymentMethods.contains(record.paymentType) {
                    paymentMethods.append(record.paymentType)
                }
                
                guard record.vehicle != nil else { continue }
                let vehicle = record.vehicle!
                if !vehicles.contains(where: { $0.id == vehicle.id }) {
                    vehicles.append(vehicle)
                }
                
                guard record.vehicle!.vehicleCategory != nil else { continue }
                let category = record.vehicle!.vehicleCategory!
                if !vehicleCategories.contains(where: { $0.id == category.id }) {
                    vehicleCategories.append(category)
                }
            }
            
            showProgressView = false
        }
    }
    
    func delete() async {
        Task {
            for index in self.deleteIndexSet {
                let fuel = fuelRecords[index]
                print("Deleteing \(fuel.id) \(fuel.amount)")
                await fuelService.deleteFuelRecord(id: fuel.id)
                await refreshList()
            }
        }
    }
}

#Preview {
    FuelRecordsView(fuelRecords: [])
}
