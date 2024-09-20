//
//  Fuel_RecordsApp.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

@main
struct Fuel_RecordsApp: App {
    @State private var httpUtil = HttpUtil()
    
    var body: some Scene {
        WindowGroup {
            ContentView(httpUtil: $httpUtil)
//                .environment(httpUtil)
        }
    }
}
