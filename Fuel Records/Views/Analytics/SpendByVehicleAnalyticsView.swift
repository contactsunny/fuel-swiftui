//
//  CostByVehicleView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI
import Charts

struct SpendByVehicleAnalyticsView: View {
    
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
//                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                    .onEnded({ value in
//                        if value.translation.width < 0 {
//                            // left
//                            viewToShow = "list"
//                        }
//                        
//                        if value.translation.width > 0 {
//                            // right
//                        }
//                        if value.translation.height < 0 {
//                            // up
//                        }
//                        
//                        if value.translation.height > 0 {
//                            // down
//                        }
//                    }))
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
        .navigationTitle("Spend By Vehicle")
        .task {
            createChartData()
        }
    }
    
    func createChartData() {
        for record in fuelRecords {
            var chartData: ChartData
            
            if !chartDataList.contains(where: { $0.id == record.vehicleId }) {
                chartData = ChartData(
                    id: record.vehicleId, name: record.vehicle?.name ?? "Unknown",
                    value: record.amount
                )
                chartDataList.append(chartData)
            } else {
                chartData = getChartDataByVehicle(vehicle: record.vehicle!)
                chartData.value += record.amount
            }
        }
        
        chartDataList = chartDataList.sorted { $0.value > $1.value }
    }
    
    func getChartDataByVehicle(vehicle: Vehicle) -> ChartData {
        for data in chartDataList {
            if data.id == vehicle.id {
                return data
            }
        }
        return ChartData(id: vehicle.id, name: vehicle.name, value: 0.0)
    }
}

@Observable
class ChartData {
    let id: String
    let name: String
    var value: Double
    
    internal init(id: String, name: String, value: Double) {
        self.id = id
        self.name = name
        self.value = value
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
    
    SpendByVehicleAnalyticsView(fuelRecords: .constant(fuels))
}
