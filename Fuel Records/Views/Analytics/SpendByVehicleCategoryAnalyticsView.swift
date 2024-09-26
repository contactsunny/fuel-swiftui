//
//  CostByVehicleCategoryanalyticsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 24/09/24.
//

import SwiftUI
import Charts

struct SpendByVehicleCategoryAnalyticsView: View {
    
    @Binding var fuelRecords: [Fuel]
    @State var chartDataList: [ChartData] = []
    @State var viewToShow: String = "chart"
    
    var body: some View {
        VStack {
            Picker("", selection: $viewToShow) {
                Text("Chart").tag("chart")
                Text("List").tag("list")
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            if viewToShow == "chart" {
                VStack {
                    Chart {
                        ForEach(chartDataList, id: \.id) { data in
                            SectorMark(
                                angle: .value("Sum", data.value)
                            )
                            .foregroundStyle(by: .value("Type", data.name))
                            .annotation(position: .overlay) {
                                Text("\(data.value, specifier: "%.2f")")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    List {
                        ForEach($chartDataList, id: \.id) {
                            data in
                            HStack {
                                Text("\(data.wrappedValue.name)")
                                Spacer()
                                Text("Rs. \(data.wrappedValue.value, specifier: "%.2f")")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Spend By Vehicle Category")
        .task {
            createChartData()
        }
    }
    
    func createChartData() {
        for record in fuelRecords {
            var chartData: ChartData
            
            if !chartDataList.contains(where: { $0.id == record.vehicleCategoryId }) {
                chartData = ChartData(
                    id: record.vehicleCategoryId!, name: record.vehicle!.vehicleCategory!.name,
                    value: record.amount
                )
                chartDataList.append(chartData)
            } else {
                chartData = getChartDataByVehicleCategory(category: record.vehicle!.vehicleCategory!)
                chartData.value += record.amount
            }
        }
        
        chartDataList = chartDataList.sorted { $0.value > $1.value }
    }
    
    func getChartDataByVehicleCategory(category: VehicleCategory) -> ChartData {
        for data in chartDataList {
            if data.id == category.id {
                return data
            }
        }
        return ChartData(id: category.id, name: category.name, value: 0.0)
    }
}

#Preview {
    let fuel1 = Fuel(
        id: "someID",
        userId: "someId",
        date: 1719923258,
        vehicleId: "someId",
        litres: 23.45,
        amount: 1234.56,
        costPerLitre: 90.12,
        fuelType: "DIESEL",
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
    
    let fuel2 = Fuel(
        id: "someID1",
        userId: "someId",
        date: 1719923258,
        vehicleId: "someId1",
        litres: 23.45,
        amount: 1234.56,
        costPerLitre: 90.12,
        fuelType: "PETROL",
        paymentType: "CREDIT_CARD",
        vehicleCategoryId: "someId1",
        createdAt: 1719923258485,
        updatedAt: 1719923258485,
        vehicle: Vehicle(
            id: "someID1",
            name: "RE Thunderbird 500",
            vehicleNumber: "KA09 MH1740",
            vehicleCategory: VehicleCategory(
                id: "someId1",
                name: "Bike"
            )
        )
    )
    
    let fuels: [Fuel] = [fuel1, fuel2]
    
    SpendByVehicleCategoryAnalyticsView(fuelRecords: .constant(fuels))
}
