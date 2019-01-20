//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Ndoo H on 16/01/2019.
//  Copyright © 2019 Ndoo H. All rights reserved.
//

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
