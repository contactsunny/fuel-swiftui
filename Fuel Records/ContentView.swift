//
//  ContentView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @Binding var httpUtil: HttpUtil

    var body: some View {
        TabView(selection:$selection) {
            FuelRecordsView(fuelRecords: []).tabItem {
                Image(systemName: "fuelpump")
                Text("Fuel Logs")
            }.tag(0)
            
            AnalyticsView().tabItem {
                Image(systemName: "chart.xyaxis.line")
                Text("Reports")
            }.tag(1)
            
            SettingsView().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }.tag(2)
        }
    }
}

#Preview {
    ContentView(httpUtil: .constant(HttpUtil()))
}
