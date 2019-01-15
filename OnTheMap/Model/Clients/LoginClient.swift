//
//  LoginClient.swift
//  OnTheMap
//
//  Created by Frederik Skytte on 15/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class LoginClient {
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        case getSession
        case signUp
        
        var stringValue: String {
            switch self {
                case .getSession: return Endpoints.base + "/session"
                case .signUp: return "https://www.udacity.com/account/auth#!/signup"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(un: String, pw: String, completion: @escaping (Bool, Error?) -> Void) {

        let body = LoginRequest(udacity: CredentialsRequest(username: un, password: pw))
        taskForPOSTRequest(url: Endpoints.getSession.url, requestBody: body, responseType: LoginResponse.self) { (responseObject, error) in
            guard let responseObject = responseObject else {
                completion(false, error)
                return
            }
            
            print("Logged in!")
            print(responseObject)
            
            if(responseObject.account.registered){
                Auth.sessionId = responseObject.session.id
                completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }

    
    class func logout(completion: @escaping () -> Void) {
        /*
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.requestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
        */
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            catch {
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData = try! JSONEncoder().encode(requestBody)
        let string1 = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print(string1)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if data.count == 0 {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                }
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try JSONDecoder().decode(responseType, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
