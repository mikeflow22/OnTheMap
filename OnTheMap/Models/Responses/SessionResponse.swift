//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: AccountInformation
    let session: SessionInformation
}

struct AccountInformation: Codable {
    let registered: Bool
    let key: String
}

struct SessionInformation: Codable {
    let id: String
    let expiration: String
}
