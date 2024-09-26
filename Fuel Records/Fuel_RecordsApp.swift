//
//  Fuel_RecordsApp.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 20/09/24.
//

import SwiftUI

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        print(">> your code here !!")
//        return true
//    }
//}

@main
struct Fuel_RecordsApp: App {
    @State private var httpUtil = HttpUtil()
    
    init() {
        let preferencesService = PreferencesService()
        Task {
            let preferences = await preferencesService.getPreferences()
            if let encoded = try? JSONEncoder().encode(preferences) {
                UserDefaults.standard.set(encoded, forKey: "preferences")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(httpUtil: $httpUtil)
        }
    }
}
