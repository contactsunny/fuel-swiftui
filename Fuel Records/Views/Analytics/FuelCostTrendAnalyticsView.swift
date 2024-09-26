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
    @State var annotationPosition: AnnotationPosition = .top
    
    var body: some View {
        VStack {
            Picker("", selection: $viewToShow) {
                Text("Chart").tag("chart")
                Text("List").tag("list")
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            if viewToShow == "chart" {
                    Chart {
                        ForEach(chartDataList, id: \.id) { chartData in
                            LineMark(
                                x: .value("Date", chartData.date),
                                y: .value("Amount", chartData.value)
                            )
//                            .symbol {
//                                Circle()
////                                    .fill(.blue)
//                                    .frame(width: 10)
//                                    .shadow(radius: 2)
//                            }
                            
//                            PointMark(
//                                x: .value("Date", chartData.date),
//                                y: .value("Amount", chartData.value)
//                            )
//                            .opacity(0)
//                            .annotation(position: .overlay,
//                                        alignment: .bottom,
//                                        spacing: 10) {
//                                Text("\(chartData.value, specifier: "%.2f")")
//                            }
                        }
                    }
//                    .chartOverlay { proxy in
//                        GeometryReader { geometry in
//                            ZStack(alignment: .top) {
//                                Rectangle().fill(.clear).contentShape(Rectangle())
////                                    .onTapGesture { location in
////                                        updateSelectedState(at: location, proxy: proxy, geometry: geometry)
////                                    }
//                            }
//                        }
//                    }
                    .padding()
            } else {
                VStack {
                    List {
                        ForEach($chartDataList, id: \.id) {
                            data in
                            HStack {
                                Text("\(CustomUtil.getFormattedDateFromTimestamp(timestamp: data.wrappedValue.timestamp))")
                                Spacer()
                                Text("Rs. \(data.wrappedValue.value, specifier: "%.2f")")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Fuel Cost Trend")
        .task {
            createChartData()
        }
    }
    
    func createChartData() {
        var count = 0
        let calendar = Calendar.autoupdatingCurrent
        
        for record in fuelRecords {
            if count >= 10 {
                break
            }
            let date = Date(timeIntervalSince1970: record.date / 1000)
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
            
            let chartData = LineChartData(
                id: record.id,
                date: calendar.date(from: DateComponents(year: calendarDate.year, month: calendarDate.month, day: calendarDate.day))!,
                value: record.costPerLitre,
                timestamp: record.date
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
    var timestamp: Double
    
    internal init(id: String, date: Date, value: Double, timestamp: Double) {
        self.id = id
        self.date = date
        self.value = value
        self.timestamp = timestamp
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
