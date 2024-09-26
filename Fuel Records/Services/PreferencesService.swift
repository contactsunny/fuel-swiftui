//
//  PreferencesService.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import Foundation

@Observable
class PreferencesService {
    private var httpUtil: HttpUtil = HttpUtil()
    private let endpoint: String = "preferences"
    
    func getPreferences() async -> Preferences? {
        var preferences: Preferences?
        let data = await self.httpUtil.makeGetCall(endpoint: endpoint)
        let decoder = JSONDecoder()
        
        do {
            let preferencesReponse = try decoder.decode(PreferencesApiResponse.self, from: data!)
            preferences = preferencesReponse.data
        } catch let error {
            print(error)
        }
        
        return preferences
    }
    
    func savePreferences(preferences: Preferences) async -> Preferences? {
        do {
            let jsonData = try JSONEncoder().encode(preferences)
            let data = await self.httpUtil.makePostCall(endpoint: endpoint, data: jsonData)
            let decoder = JSONDecoder()
            let preferencesResponse = try decoder.decode(PreferencesApiResponse.self, from: data!)
            return preferencesResponse.data
        } catch let error {
            print(error)
        }
        return nil
    }
}
