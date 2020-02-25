//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable {
    let session: LogoutSessionInformation //probably can use sessionResponse SessionInformation struct here
}

struct LogoutSessionInformation: Codable {
    let id: String?
    let expiration: String
}

