//
//  SettingsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Vehicles & More")) {
                    NavigationLink(destination: VehiclesListView()) {
                        Text("Vehicles")
                    }
                    NavigationLink(destination: VehicleCategoryListView()) {
                        Text("Vehicle Categories")
                    }
                }
            }.navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
