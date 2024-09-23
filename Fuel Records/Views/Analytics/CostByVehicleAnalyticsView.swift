//
//  CostByVehicleView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 23/09/24.
//

import SwiftUI
import Charts

struct CostByVehicleAnalyticsView: View {
    
    @Binding var fuelRecords: [Fuel]
    @State var chartDataList: [ChartData] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Chart {
                    ForEach(chartDataList, id: \.id) { data in
                        SectorMark(
                            angle: .value("Sum", data.value),
                            angularInset: 2.0
                        )
                        .foregroundStyle(by: .value("Type", data.name))
                        .annotation(position: .overlay) {
                            Text("\(data.value, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(height: 500)
            }
        }.task {
            createChartData()
        }
    }
    
    func createChartData() {
        for record in fuelRecords {
            var chartData: ChartData
            
            if !chartDataList.contains(where: { $0.id == record.vehicleId }) {
                print("Not found in list")
                chartData = ChartData(
                    id: record.vehicleId, name: record.vehicle?.name ?? "Unknown",
                    value: record.amount
                )
                chartDataList.append(chartData)
            } else {
                print("Found in list")
                chartData = getChartDataByVehicle(vehicle: record.vehicle!)
                chartData.value += record.amount
            }
        }
        
        for data in chartDataList {
            print("\(data.name): \(data.value)")
        }
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
    
    CostByVehicleAnalyticsView(fuelRecords: .constant(fuels))
}
