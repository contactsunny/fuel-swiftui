//
//  SettingsView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 21/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    let year = String(Calendar.current.component(.year, from: Date()))
    
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
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Text("About")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("© \(year)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("[Sunny Srinidhi](https://blog.contactsunny.com)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }.navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
