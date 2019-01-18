//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Frederik Skytte on 15/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class ParseClient {

    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    enum Endpoints {
        static let base = "https://parse.udacity.com/parse/classes"
        
        case get100Locations
        case sendLocation
        
        var stringValue: String {
            switch self {
            case .get100Locations: return Endpoints.base + "/StudentLocation?limit=100"
            case .sendLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getLocationList(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.get100Locations.url, responseType: StudentResults.self) { (responseObject, error) in
            guard let responseObject = responseObject else {
                completion([], error)
                return
            }
            completion(responseObject.results, nil)
        }
    }
    
    class func sendLocation(userLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.sendLocation.url, requestBody: userLocation, responseType: StudentPostLocationResponse.self, completion: { (responseObject, error) in
            guard responseObject != nil else {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.addValue(appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch let DecodingError.dataCorrupted(context) {
                print(context)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch {
                print("error: ", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestBody: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch let DecodingError.dataCorrupted(context) {
                print(context)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } catch {
                print("error: ", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
