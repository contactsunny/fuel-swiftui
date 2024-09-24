//
//  FuelCostTrendAnalyticsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 24/09/24.
//

import SwiftUI
import Charts

struct FuelCostTrendAnalyticsView: View {
    
    @Binding var fuelRecords: [Fuel]
    @State var chartDataList: [LineChartData] = []
    @State var viewToShow: String = "chart"
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $viewToShow) {
                    Text("Chart").tag("chart")
                    Text("List").tag("list")
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
                if viewToShow == "chart" {
//                    VStack {
                        Chart(chartDataList, id: \.id) {
                            LineMark(
                                x: .value("Date", $0.date),
                                y: .value("Amount", $0.value)
                            )
                            .foregroundStyle(by: .value("Type", $0.date))
                        }
//                    }
                } else {
                    VStack {
                        List {
                            ForEach($chartDataList, id: \.id) {
                                data in
                                HStack {
                                    Text("\(data.wrappedValue.date)")
                                    Spacer()
                                    Text("Rs. \(data.wrappedValue.value, specifier: "%.2f")")
                                }
                            }
                        }
                    }
                }
            }
        }.task {
            createChartData()
        }
    }
    
    func createChartData() {
        var count = 0
        for record in fuelRecords {
            if count >= 10 {
                break
            }
            let chartData = LineChartData(
                id: record.id,
                date: Date(timeIntervalSince1970: record.date / 1000),
                value: record.costPerLitre
            )
            print("\(chartData.value)")
            chartDataList.append(chartData)
            count += 1
        }
    }
}

@Observable
class LineChartData {
    let id: String
    let date: Date
    var value: Double
    
    internal init(id: String, date: Date, value: Double) {
        self.id = id
        self.date = date
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
    
    FuelCostTrendAnalyticsView(fuelRecords: .constant(fuels))
}
