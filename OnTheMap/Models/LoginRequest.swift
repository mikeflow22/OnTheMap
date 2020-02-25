//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

//Requests go in the httpbody
struct LoginRequest: Codable {
    let udacity: LoginData
}

struct LoginData: Codable {
    let username: String
    let password: String
}
