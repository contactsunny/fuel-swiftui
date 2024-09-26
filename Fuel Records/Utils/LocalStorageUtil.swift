//
//  LocalStorageUtil.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import Foundation

class LocalStorageUtil {
    
    static func getPreferencesFromLocalStorage() -> Preferences? {
        var localPreferences: Preferences?
        if let data = UserDefaults.standard.data(forKey: "preferences") {
            if let decoded = try? JSONDecoder().decode(Preferences.self, from: data) {
                localPreferences = decoded
            }
        }
        
        return localPreferences
    }
}
