//
//  HttpUtil.swift
//  Night Watch
//
//  Created by TG, Srinidhi on 18/09/24.
//

import Foundation
import OSLog

@Observable
class HttpUtil {
    
    private let logger = Logger.init(subsystem: "com.contactsunny.fuelrecords", category: "HttpUtil")
    private let baseUrl = "https://api.fuel.contactsunny.com/"
    private let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1ZTA3NGYxMzg0MWRlOTdkNTNiYmIxOGYiLCJlbWFpbCI6InN1bm55LjNteXNvcmVAZ21haWwuY29tIiwiY3JlYXRlZEF0IjoiMTcyNjY1NzMyODEyMSJ9.RRBUUHNWiFrA1YNv6v4GI123lHEkS170xFQBFM08qfKdzaUwJp3mq3KMukcqhyK-nu8cIU5Aljx93Pd8gGJ55g"
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 300
        
        return URLSession(configuration: config)
    }
    
    func getRequest(endpoint: String) -> URLRequest {
        let url = URL(string: self.baseUrl + endpoint)!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "token")
        return request
    }
    
    func makeGetCall(endpoint: String) async -> Data? {
        let request = getRequest(endpoint: endpoint)
        do {
            let result = try await self.session.data(for: request)
            
//            guard let response = result.1 as? HTTPURLResponse else { return "Not a valid response" }
//            guard (200...299).contains(response.statusCode) else { return "Not a valid response code" }
            
//            var content = String(data: result.0, encoding: .utf8)!
            
            return result.0
        } catch let error as URLError {
            self.logger.error("\(error.localizedDescription)")
        } catch {
            self.logger.error("\(error.localizedDescription)")
        }
        return nil
    }
    
    func makePostCall(endpoint: String, data: Data) async -> Data? {
        var request = getRequest(endpoint: endpoint)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let result = try await self.session.data(for: request)
            return result.0
        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
        return nil
    }
    
    func makePutCall(endpoint: String, data: Data) async -> Data? {
        var request = getRequest(endpoint: endpoint)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let result = try await self.session.data(for: request)
            return result.0
        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
        return nil
    }
    
    func makeDeleteCall(endpoint: String) async {
        var request = getRequest(endpoint: endpoint)
        request.httpMethod = "DELETE"
//        request.httpBody = data
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let _ = try await self.session.data(for: request)
//            return result.0
        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
    }
}
