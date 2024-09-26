//
//  SpendPerMonthAnalyticsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import SwiftUI
import Charts

struct SpendPerMonthAnalyticsView: View {
    
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
                            BarMark(
                                x: .value("Date", data.name),
                                y: .value("Amount", data.value)
                            )
                        }
                    }
                    .padding()
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
        .navigationTitle("Spend By Fuel Type")
        .task {
            createChartData()
        }
    }
    
    func createChartData() {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "MMM yyyy"
        
        for record in fuelRecords {
            let date = Date(timeIntervalSince1970: record.date / 1000)
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
            let id = "\(calendarDate.month!)\(calendarDate.year!)"
            let name = dtf.string(from: date)
            let value = record.amount
            var data: ChartData? = getChartDataById(id: id)
            if data == nil {
                data = ChartData(id: id, name: name, value: value)
                chartDataList.append(data!)
            } else {
                data!.value += value
            }
        }
    }
    
    func getChartDataById(id: String) -> ChartData? {
        for data in chartDataList {
            if data.id == id {
                return data
            }
        }
        return nil
    }
}

#Preview {
    let fuel1 = Fuel(
        id: "someID",
        userId: "someId",
        date: 1719923258000,
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
        date: 1719923258000,
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
    
    SpendPerMonthAnalyticsView(fuelRecords: .constant(fuels))
}
