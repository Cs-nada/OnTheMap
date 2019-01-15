//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Frederik Skytte on 15/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//
/*
 {
 "account":{
 "registered":true,
 "key":"3903878747"
 },
 "session":{
 "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
 "expiration":"2015-05-10T16:48:30.760460Z"
 }
 }
 */

import Foundation

struct LoginResponse: Codable {
    let account: AccountResp
    let session: SessionResp
}

struct AccountResp: Codable {
    let registered: Bool
    let key: String
}

struct SessionResp: Codable {
    let id: String
    let expiration: String
}
